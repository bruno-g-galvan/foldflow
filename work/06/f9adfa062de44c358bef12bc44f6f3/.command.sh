#!/bin/bash -ue
python3 -c "
from Bio.PDB import PDBParser
import pandas as pd

parser = PDBParser(QUIET=True)
structure = parser.get_structure('insulin_human', 'insulin_human.pdb')

records = []
for model in structure:
    for chain in model:
        for residue in chain:
            for atom in residue:
                if atom.name == 'CA':
                    records.append({
                        'protein_id': 'insulin_human',
                        'residue_num': residue.id[1],
                        'residue_name': residue.resname,
                        'plddt': round(atom.bfactor, 2)
                    })

import pandas as pd
df = pd.DataFrame(records)
mean_plddt = df['plddt'].mean()
print('insulin_human: mean pLDDT = ' + str(round(mean_plddt, 2)))
df.to_csv('insulin_human_plddt.tsv', sep='	', index=False)
print('Scores saved to insulin_human_plddt.tsv')
    "
