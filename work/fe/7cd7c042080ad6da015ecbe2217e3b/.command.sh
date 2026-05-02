#!/bin/bash -ue
python3 -c "
seq = 'MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAEDLQVGQVELGGGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN'
valid_aa = set('ACDEFGHIKLMNPQRSTVWY')
invalid = set(seq) - valid_aa
if invalid:
    raise ValueError('Sequence insulin_human contains invalid characters: ' + str(invalid))
if len(seq) < 10:
    raise ValueError('Sequence insulin_human too short (' + str(len(seq)) + ' aa). Minimum: 10.')
if len(seq) > 1024:
    raise ValueError('Sequence insulin_human too long (' + str(len(seq)) + ' aa). ESMFold max: 1024.')
print('Validated: insulin_human (' + str(len(seq)) + ' aa)')
"
