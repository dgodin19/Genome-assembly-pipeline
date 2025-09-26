#!/usr/bin/env nextflow

process PILON {
    label 'process_high'
    conda 'envs/pilon_env.yml'
    publishDir "${params.outdir}/pilon"

    input:
    tuple val(name), path(genome)
    tuple val(name), path(bam)

    output:
    tuple val(name), path("${name}.pilon.fasta")

    shell:
    """ 
    pilon --genome $genome --frags $bam --output ${name} -Xmx32G
    mv ${name}.fasta ${name}.pilon.fasta
    """

}