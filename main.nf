#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include { VALIDATE_FASTA } from './modules/validate_fasta'
include { ESMFOLD        } from './modules/esmfold'
include { EXTRACT_SCORES } from './modules/extract_scores'

workflow {
    if (!params.input) {
        error "No input file specified. Use --input sequences.fasta"
    }

    ch_sequences = Channel
        .fromPath(params.input, checkIfExists: true)
        .splitFasta(record: [id: true, seqString: true])

    VALIDATE_FASTA(ch_sequences)
    ESMFOLD(VALIDATE_FASTA.out.valid)
    EXTRACT_SCORES(ESMFOLD.out.pdb)
}
