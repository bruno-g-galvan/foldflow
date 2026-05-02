#!/bin/bash -ue
python3 -c "
seq = 'LSDEDFKAVFGMTRSAFANLPLWKQQNLKKEKGLF'
valid_aa = set('ACDEFGHIKLMNPQRSTVWY')
invalid = set(seq) - valid_aa
if invalid:
    raise ValueError('Sequence villin_headpiece contains invalid characters: ' + str(invalid))
if len(seq) < 10:
    raise ValueError('Sequence villin_headpiece too short (' + str(len(seq)) + ' aa). Minimum: 10.')
if len(seq) > 1024:
    raise ValueError('Sequence villin_headpiece too long (' + str(len(seq)) + ' aa). ESMFold max: 1024.')
print('Validated: villin_headpiece (' + str(len(seq)) + ' aa)')
"
