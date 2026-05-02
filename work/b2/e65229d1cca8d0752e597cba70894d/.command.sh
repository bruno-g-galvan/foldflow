#!/bin/bash -ue
python3 -c "
seq = 'NLYIQWLKDGGPSSGRPPPS'
valid_aa = set('ACDEFGHIKLMNPQRSTVWY')
invalid = set(seq) - valid_aa
if invalid:
    raise ValueError('Sequence trp_cage contains invalid characters: ' + str(invalid))
if len(seq) < 10:
    raise ValueError('Sequence trp_cage too short (' + str(len(seq)) + ' aa). Minimum: 10.')
if len(seq) > 1024:
    raise ValueError('Sequence trp_cage too long (' + str(len(seq)) + ' aa). ESMFold max: 1024.')
print('Validated: trp_cage (' + str(len(seq)) + ' aa)')
"
