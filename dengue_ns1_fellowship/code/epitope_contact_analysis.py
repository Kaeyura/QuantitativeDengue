

import numpy as np

CONTACT_CUTOFF = 4.5   # Angstrom, upper bound for a genuine contact
CLASH_FLOOR = 1.5      # Angstrom, lower bound -- below this is a clash artifact


def _is_heavy(atom_name: str) -> bool:
    """True if atom_name is a heavy (non-hydrogen) atom, given PDB naming
    conventions including RF2/RFdiffusion's leading-digit hydrogen names
    (e.g. '1HG', '2HD1')."""
    if atom_name.startswith("H"):
        return False
    if len(atom_name) >= 2 and atom_name[0].isdigit() and atom_name[1] == "H":
        return False
    return True


def parse_chains_heavy(pdb_path: str) -> dict:
    """Parse a PDB file into {chain: {resnum: {atom_name: (x,y,z)}}},
    heavy atoms only."""
    chains: dict = {}
    with open(pdb_path) as f:
        for line in f:
            if not line.startswith("ATOM"):
                continue
            atom_name = line[12:16].strip()
            if not _is_heavy(atom_name):
                continue
            chain = line[21]
            resnum = int(line[22:26])
            x, y, z = float(line[30:38]), float(line[38:46]), float(line[46:54])
            chains.setdefault(chain, {}).setdefault(resnum, {})[atom_name] = (x, y, z)
    return chains


def _min_dist(chains: dict, binder_chain: str, target_chain: str, target_resnum: int):
    """Minimum heavy-atom distance between the binder chain and one target residue."""
    if target_resnum not in chains.get(target_chain, {}):
        return None
    tatoms = np.array(list(chains[target_chain][target_resnum].values()))
    batoms = np.array([xyz for res in chains[binder_chain].values() for xyz in res.values()])
    d = np.sqrt(((batoms[:, None, :] - tatoms[None, :, :]) ** 2).sum(-1))
    return float(d.min())


def analyze_complex(pdb_path: str, binder_chain: str, target_chain: str,
                     epitope_range, hotspots: list,
                     contact_cutoff: float = CONTACT_CUTOFF,
                     clash_floor: float = CLASH_FLOOR,
                     residue_offset: int = 0) -> dict:
    """
    Analyze a binder:target complex PDB for epitope contacts and hotspot
    engagement, with clash-floor correction.

    residue_offset: defined so that  renumbered_resnum = native_resnum + residue_offset
    (i.e. add residue_offset to a NATIVE residue number to get the number as it
    actually appears in the PDB's target chain). Example: RF2 output renumbers
    the target chain sequentially starting at 119 while native NS1 numbering
    starts at 255 for the same residue -> residue_offset = 119 - 255 = -136.
    Set residue_offset=0 if the PDB already uses native numbering (true for
    Boltz-2 output, which does not renumber its input).
    """
    chains = parse_chains_heavy(pdb_path)
    if binder_chain not in chains or target_chain not in chains:
        return {"error": f"chains not found; present: {sorted(chains.keys())}"}

    epitope_set = set(epitope_range)
    hotspot_dists = {}
    for h in hotspots:
        renum = h + residue_offset
        hotspot_dists[h] = _min_dist(chains, binder_chain, target_chain, renum)
    hotspots_engaged = sorted(
        h for h, d in hotspot_dists.items() if d is not None and clash_floor <= d <= contact_cutoff
    )

    n_epitope_contacts = 0
    n_total_contacts = 0
    contact_residues_native = []
    for target_resnum in chains[target_chain]:
        d = _min_dist(chains, binder_chain, target_chain, target_resnum)
        if d is not None and clash_floor <= d <= contact_cutoff:
            n_total_contacts += 1
            native = target_resnum - residue_offset
            contact_residues_native.append(native)
            if native in epitope_set:
                n_epitope_contacts += 1

    # clash diagnostics
    batoms = np.array([xyz for res in chains[binder_chain].values() for xyz in res.values()])
    tatoms = np.array([xyz for res in chains[target_chain].values() for xyz in res.values()])
    d_all = np.sqrt(((batoms[:, None, :] - tatoms[None, :, :]) ** 2).sum(-1))
    overall_min_dist = float(d_all.min())
    n_severe_clash_pairs = int((d_all < 1.0).sum())

    return {
        "hotspot_dists": {k: (round(v, 2) if v is not None else None) for k, v in hotspot_dists.items()},
        "hotspots_engaged": hotspots_engaged,
        "n_epitope_contacts": n_epitope_contacts,
        "n_total_contacts": n_total_contacts,
        "contact_residues_native": sorted(contact_residues_native),
        "on_epitope": n_epitope_contacts >= 3,
        "overall_min_heavy_atom_dist_A": round(overall_min_dist, 3),
        "n_severe_clash_pairs_lt_1A": n_severe_clash_pairs,
    }


def passes_locked_gate(complex_plddt: float, iptm: float, complex_ipde: float,
                        n_epitope_contacts: int,
                        plddt_min: float = 0.80, iptm_min: float = 0.7,
                        ipde_max: float = 5.0, epitope_contacts_min: int = 3) -> bool:
    """Apply this project's locked acceptance gate. Note: this gate does NOT
    separately threshold on the number of distinct hotspots engaged -- only
    on total epitope contact count. hotspots_engaged (from analyze_complex)
    is reported for diagnostic purposes."""
    return (complex_plddt > plddt_min and iptm > iptm_min and
            complex_ipde < ipde_max and n_epitope_contacts >= epitope_contacts_min)


if __name__ == "__main__":
    import sys, json
    if len(sys.argv) < 6:
        print("usage: epitope_contact_analysis.py <pdb> <binder_chain> <target_chain> "
              "<epitope_start> <epitope_end> [hotspot1,hotspot2,...] [residue_offset]")
        sys.exit(1)
    pdb, bchain, tchain, estart, eend = sys.argv[1:6]
    hotspots = [int(x) for x in sys.argv[6].split(",")] if len(sys.argv) > 6 else []
    offset = int(sys.argv[7]) if len(sys.argv) > 7 else 0
    result = analyze_complex(pdb, bchain, tchain, range(int(estart), int(eend) + 1),
                              hotspots, residue_offset=offset)
    print(json.dumps(result, indent=2))
