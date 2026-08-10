#!/usr/bin/env python3

import argparse, glob, json, sys
from collections import defaultdict
import numpy as np

EPITOPE = set(range(261, 306))          # 261-305 inclusive
TIP     = set(range(311, 353))          # 311-352 inclusive
HOTSPOTS_A = {269, 272, 274}
HOTSPOTS_B = {294, 296}
HOTSPOTS   = HOTSPOTS_A | HOTSPOTS_B
CONTACT_CUTOFF = 4.5                    # heavy-atom, Angstrom

# 2B7 crystallographic reference on the same predictor (gate_calibration_finding.md)
REF_2B7 = {"iptm": 0.455, "interface_pae_A": 6.48}


def parse_pdb(path):
    """Return {chain: [(resseq, atomname, x, y, z), ...]} for heavy atoms (ATOM records)."""
    chains = defaultdict(list)
    with open(path) as fh:
        for line in fh:
            if not line.startswith(("ATOM", "HETATM")):
                continue
            atom = line[12:16].strip()
            element = line[76:78].strip()
            if atom.startswith("H") or element == "H":
                continue                # skip hydrogens -> heavy-atom only
            chain = line[21].strip() or "_"
            try:
                resseq = int(line[22:26])
                x = float(line[30:38]); y = float(line[38:46]); z = float(line[46:54])
            except ValueError:
                continue
            chains[chain].append((resseq, atom, x, y, z))
    return chains


def contacts(binder_atoms, ns1_atoms, cutoff=CONTACT_CUTOFF):
    """NS1 residue numbers within `cutoff` heavy-atom distance of any binder atom."""
    if not binder_atoms or not ns1_atoms:
        return set()
    b = np.array([(a[2], a[3], a[4]) for a in binder_atoms])
    n = np.array([(a[2], a[3], a[4]) for a in ns1_atoms])
    n_res = np.array([a[0] for a in ns1_atoms])
    hit = set()
    # blocked distance computation to keep memory bounded
    for i in range(0, len(n), 2000):
        chunk = n[i:i + 2000]
        d = np.sqrt(((chunk[:, None, :] - b[None, :, :]) ** 2).sum(-1))
        close = np.where(d.min(axis=1) <= cutoff)[0]
        for j in close:
            hit.add(int(n_res[i + j]))
    return hit


def score_one(path, binder_chain, ns1_chain, iptm=None, interface_pae=None, plddt=None):
    chains = parse_pdb(path)
    if binder_chain not in chains or ns1_chain not in chains:
        raise SystemExit(f"{path}: chains {binder_chain!r}/{ns1_chain!r} not found; "
                         f"present: {sorted(chains)}")
    site = contacts(chains[binder_chain], chains[ns1_chain])
    epi = sorted(site & EPITOPE)
    tip = sorted(site & TIP)
    hs_A = sorted(site & HOTSPOTS_A)
    hs_B = sorted(site & HOTSPOTS_B)
    hotspots = sorted(site & HOTSPOTS)
    n_epi = len(epi)
    on_epitope = n_epi >= 4                          # methods.md operating definition
    fidelity_pass = (on_epitope and len(hotspots) >= 2 and len(hs_A) >= 1)
    res = {
        "file": path,
        "n_epitope_contacts_261_305": n_epi,
        "epitope_contacts": epi,
        "tip_contacts_311_352": tip,
        "hotspots_engaged": hotspots,
        "clusterA_hotspots": hs_A,
        "clusterB_hotspots": hs_B,
        "on_epitope": on_epitope,
        "epitope_fidelity_pass": fidelity_pass,
        "iptm": iptm, "interface_pae_A": interface_pae, "plddt": plddt,
    }
    if iptm is not None:
        res["iptm_vs_2B7_ref"] = round(iptm - REF_2B7["iptm"], 3)
    if interface_pae is not None:
        res["interface_pae_vs_2B7_ref_A"] = round(interface_pae - REF_2B7["interface_pae_A"], 3)
    if plddt is not None:
        res["plddt_fold_guard_pass"] = plddt > 0.8
    return res


def aggregate_seeds(per_seed):
    """Aggregate a list of single-seed score dicts into per-design benchmark metrics."""
    n = len(per_seed)
    on = sum(1 for r in per_seed if r["on_epitope"])
    # per-seed hotspot frequency (NEVER a union)
    freq = {}
    for hs in sorted(HOTSPOTS):
        c = sum(1 for r in per_seed if hs in r["hotspots_engaged"])
        if c:
            freq[hs] = f"{c}/{n}"
    # consensus = intersection of epitope-contact sets over ON-EPITOPE seeds
    onep = [set(r["epitope_contacts"]) for r in per_seed if r["on_epitope"]]
    consensus = sorted(set.intersection(*onep)) if onep else []
    mean_epi = round(float(np.mean([r["n_epitope_contacts_261_305"] for r in per_seed])), 2)
    return {
        "seeds": n,
        "on_epitope_rate": f"{on}/{n}",
        "mean_epitope_contacts": mean_epi,
        "per_seed_hotspot_frequency": freq or "none",
        "consensus_size": len(consensus),
        "consensus_contacts": consensus,
        "hotspots_in_3plus_seeds": [h for h in freq if int(freq[h].split('/')[0]) >= 3] or "none",
    }


def main(argv=None):
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("pattern", help="PDB path or glob (multiple = seeds of one design)")
    p.add_argument("--binder-chain", default="B")
    p.add_argument("--ns1-chain", default="A")
    p.add_argument("--json", action="store_true", help="emit JSON")
    a = p.parse_args(argv)
    files = sorted(glob.glob(a.pattern)) or [a.pattern]
    per_seed = [score_one(f, a.binder_chain, a.ns1_chain) for f in files]
    out = {"per_seed": per_seed}
    if len(per_seed) > 1:
        out["aggregate"] = aggregate_seeds(per_seed)
    if a.json:
        print(json.dumps(out, indent=2))
    else:
        for r in per_seed:
            print(f"{r['file']}: epitope_contacts={r['n_epitope_contacts_261_305']} "
                  f"on_epitope={r['on_epitope']} hotspots={r['hotspots_engaged']} "
                  f"fidelity_pass={r['epitope_fidelity_pass']}")
        if "aggregate" in out:
            ag = out["aggregate"]
            print(f"\nAGGREGATE  on_epitope_rate={ag['on_epitope_rate']}  "
                  f"mean_epitope_contacts={ag['mean_epitope_contacts']}  "
                  f"hotspot_freq={ag['per_seed_hotspot_frequency']}  "
                  f"consensus_size={ag['consensus_size']}")
    return out


if __name__ == "__main__":
    main()
