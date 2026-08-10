

from collections import OrderedDict


def load_fasta(path: str) -> OrderedDict:
    """Parse a simple multi-FASTA file into {header: sequence}."""
    seqs = OrderedDict()
    name = None
    with open(path) as f:
        for line in f:
            line = line.rstrip()
            if line.startswith(">"):
                name = line[1:].strip()
                seqs[name] = ""
            elif name is not None:
                seqs[name] += line
    return seqs


def check_reference_conservation(serotypes: dict, positions: list, one_based: bool = True) -> list:
    """For each position, report whether all reference serotypes agree.
    Does NOT check against any external modeling target -- see check_target_vs_references
    for that (necessary!) additional check."""
    rows = []
    for p in positions:
        idx = p - 1 if one_based else p
        residues = {sero: seq[idx] for sero, seq in serotypes.items()}
        conserved = len(set(residues.values())) == 1
        rows.append({"position": p, "residues": residues, "conserved_among_refs": conserved})
    return rows


def check_target_vs_references(serotypes: dict, target_seq: str, positions: list,
                                one_based: bool = True) -> list:
    """For each position, report whether the ACTUAL modeling target sequence
    matches all reference serotypes. This is the check that caught a real
    divergence in this project (position 272: target=R, all refs=K)."""
    rows = []
    for p in positions:
        idx = p - 1 if one_based else p
        target_residue = target_seq[idx] if idx < len(target_seq) else None
        ref_residues = {sero: seq[idx] for sero, seq in serotypes.items()}
        conserved_among_refs = len(set(ref_residues.values())) == 1
        matches_all_refs = (target_residue is not None) and all(r == target_residue for r in ref_residues.values())
        rows.append({
            "position": p,
            "target_residue": target_residue,
            "reference_residues": ref_residues,
            "conserved_among_refs": conserved_among_refs,
            "target_matches_all_refs": matches_all_refs,
        })
    return rows


def region_identity(serotypes: dict, region: range, reference: str = "DENV2") -> dict:
    """Percent identity of each serotype vs. a reference, over a region."""
    ref_seq = serotypes[reference]
    out = {}
    for sero, seq in serotypes.items():
        if sero == reference:
            continue
        n_id = sum(1 for i in region if seq[i - 1] == ref_seq[i - 1])
        out[sero] = n_id / len(region)
    return out


if __name__ == "__main__":
    import sys, json
    if len(sys.argv) < 2:
        print("usage: denv_conservation_check.py <serotypes.fasta> [pos1,pos2,...]")
        sys.exit(1)
    fasta_path = sys.argv[1]
    positions = [int(x) for x in sys.argv[2].split(",")] if len(sys.argv) > 2 else [269, 272, 274, 294, 296]
    serotypes = load_fasta(fasta_path)
    report = check_reference_conservation(serotypes, positions)
    print(json.dumps(report, indent=2))
    print("\nNOTE: this only checks conservation AMONG the reference serotypes.")
    print("Run check_target_vs_references(serotypes, your_modeling_target_seq, positions)")
    print("to confirm your actual modeling target matches -- do not skip this step.")
