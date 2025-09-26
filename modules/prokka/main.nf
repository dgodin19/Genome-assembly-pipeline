#!/usr/bin/env nextflow

process PROKKA {
    label 'process_single'
    conda "envs/prokka_env.yml"
    publishDir "${params.outdir}/prokka"

    input:
    tuple val(name), path(fa)

    output:
    path("**/*.gff"), emit: gff

    shell:
    """
    prokka --cpus 1 --outdir annots/ --prefix $name $fa
    """
}