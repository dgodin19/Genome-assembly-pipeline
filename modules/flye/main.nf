#!/usr/bin/env nextflow

process FLYE {
    label 'process_high'
    conda 'envs/flye_env.yml'
    publishDir "${params.outdir}/flye"

    input:
    tuple val(name),path(nano)

    output:
    tuple val(name), path("assembly.fasta")

    script:
    """
    flye --nano-corr $nano -o .
    """
}