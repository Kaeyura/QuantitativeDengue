# Dengue NS1 binder pilot — timing & cost summary

Target: DENV-2 NS1 chain A (9W22, res 1-346). Hotspots P1 = A269,A272,A274,A294,A296.
Batch: 8 RFdiffusion backbones -> 2 ProteinMPNN seqs each = 16 designs -> 16 AF2-multimer complex folds.
Hardware: single NVIDIA A40 (46 GB), CUDA driver 580.159.04.

## Runtime per step
| Stage | units | wall time | per unit |
|---|---|---|---|
| RFdiffusion | 8 backbones | 1708 s (28.5 min) | 213.5 s/backbone |
| ProteinMPNN | 16 seqs (GPU) | 14 s | 0.88 s/seq |
| AF2-multimer | 16 complexes | 2884 s (48.1 min) | 180.2 s/complex |

Total GPU wall time: 4606 s = 1.279 GPU-h.
Est. pilot GPU cost: $0.563 (assumed A40 @ $0.44/h — substitute your actual RunPod rate).

## ProteinMPNN device
GPU (torch 2.5.1+cu121, cuda:NVIDIA A40) — NO CPU fallback. The 2026-07-13 env rebuild (torch 2.5.1+cu121) held; NO CPU fallback this run.

## Threshold results
0 / 16 designs pass (pLDDT>80: 0; ipTM>0.7: 0; interface pAE<5: 0).
NOTE: folds run with --msa-mode single_sequence. ipTM is systematically depressed without an MSA on the NS1 target; these numbers are a pipeline smoke test, not a verdict on the designs. See report.

## Campaign scaling (per-unit x2 seqs x2 folds)
- 100 backbones: ~16 GPU-h (~$7)
- 1000 backbones: ~160 GPU-h (~$70)
AF2-multimer dominates cost (~63%); RFdiffusion ~37%; MPNN negligible.
