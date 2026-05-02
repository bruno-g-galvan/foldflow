process EXTRACT_SCORES {
    tag "$protein_id"
    publishDir "${params.outdir}/scores", mode: 'copy'

    input:
    tuple val(protein_id), path(pdb_file)

    output:
    path "${protein_id}_plddt.tsv", emit: scores

    script:
    """
    python3 -c "
from Bio.PDB import PDBParser
import pandas as pd

parser = PDBParser(QUIET=True)
structure = parser.get_structure('${protein_id}', '${pdb_file}')

records = []
for model in structure:
    for chain in model:
        for residue in chain:
            for atom in residue:
                if atom.name == 'CA':
                    records.append({
                        'protein_id': '${protein_id}',
                        'residue_num': residue.id[1],
                        'residue_name': residue.resname,
                        'plddt': round(atom.bfactor, 2)
                    })

import pandas as pd
df = pd.DataFrame(records)
mean_plddt = df['plddt'].mean()
print('${protein_id}: mean pLDDT = ' + str(round(mean_plddt, 2)))
df.to_csv('${protein_id}_plddt.tsv', sep='\t', index=False)
print('Scores saved to ${protein_id}_plddt.tsv')
    "
    """
}
