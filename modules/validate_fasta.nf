process VALIDATE_FASTA {
    tag "$record.id"

    input:
    val record

    output:
    val record, emit: valid

    script:
    def seq = record.seqString.replaceAll(/\s/, '').toUpperCase()
    """
    python3 -c "
    seq = '${seq}'
    valid_aa = set('ACDEFGHIKLMNPQRSTVWY')
    invalid = set(seq) - valid_aa
    if invalid:
        raise ValueError('Sequence ${record.id} contains invalid characters: ' + str(invalid))
    if len(seq) < 10:
        raise ValueError('Sequence ${record.id} too short (' + str(len(seq)) + ' aa). Minimum: 10.')
    if len(seq) > 1024:
        raise ValueError('Sequence ${record.id} too long (' + str(len(seq)) + ' aa). ESMFold max: 1024.')
    print('Validated: ${record.id} (' + str(len(seq)) + ' aa)')
    "
    """
}
