import torch
import numpy as np
from transformers import AutoTokenizer, EsmForProteinFolding
from transformers.models.esm.openfold_utils.protein import to_pdb, Protein as OFProtein
from transformers.models.esm.openfold_utils.feats import atom14_to_atom37

sequence   = "LSDEDFKAVFGMTRSAFANLPLWKQQNLKKEKGLF"
protein_id = "villin_headpiece"

print(f"Loading ESMFold...")
tokenizer = AutoTokenizer.from_pretrained("facebook/esmfold_v1")
model = EsmForProteinFolding.from_pretrained(
    "facebook/esmfold_v1",
    low_cpu_mem_usage=True
)
device = "cuda" if torch.cuda.is_available() else "cpu"
model = model.to(device)
model.esm = model.esm.half()
print(f"Using device: {device}")

print(f"Predicting {protein_id} ({len(sequence)} aa)...")
inputs = tokenizer([sequence], return_tensors="pt", add_special_tokens=False)
inputs = {k: v.to(device) for k, v in inputs.items()}

with torch.no_grad():
    outputs = model(**inputs)

plddt_per_residue = outputs["plddt"][0].mean(dim=-1) * 100
mean_plddt = plddt_per_residue.mean().item()

final_atom_positions = atom14_to_atom37(outputs["positions"][-1], outputs)
outputs_np = {k: v.to("cpu").numpy() for k, v in outputs.items() if isinstance(v, torch.Tensor)}
final_atom_positions = final_atom_positions.cpu().numpy()
plddt_np = outputs_np["plddt"][0] * 100

pdb_str = to_pdb(OFProtein(
    aatype=outputs_np["aatype"][0],
    atom_positions=final_atom_positions[0],
    atom_mask=outputs_np["atom37_atom_exists"][0],
    residue_index=outputs_np["residue_index"][0] + 1,
    b_factors=plddt_np * outputs_np["atom37_atom_exists"][0],
    chain_index=outputs_np.get(
        "chain_index", np.zeros_like(outputs_np["aatype"])
    )[0],
))

with open(f"{protein_id}.pdb", "w") as f:
    f.write(pdb_str)

print(f"Mean pLDDT: {mean_plddt:.1f} / 100")
print(f"Done. Saved {protein_id}.pdb")
