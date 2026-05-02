#!/bin/bash -ue
python3 -c "
from Bio.PDB import PDBParser
import pandas as pd

parser = PDBParser(QUIET=True)
structure = parser.get_structure('trp_cage', 'trp_cage.pdb')

records = []
for model in structure:
    for chain in model:
        for residue in chain:
            for atom in residue:
                if atom.name == 'CA':
                    records.append({
                        'protein_id': 'trp_cage',
                        'residue_num': residue.id[1],
                        'residue_name': residue.resname,
                        'plddt': round(atom.bfactor, 2)
                    })

import pandas as pd
df = pd.DataFrame(records)
mean_plddt = df['plddt'].mean()
print('trp_cage: mean pLDDT = ' + str(round(mean_plddt, 2)))
df.to_csv('trp_cage_plddt.tsv', sep='	', index=False)
print('Scores saved to trp_cage_plddt.tsv')
    "
