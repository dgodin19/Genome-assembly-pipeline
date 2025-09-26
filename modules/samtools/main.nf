#!/usr/bin/env nextflow

process SAMTOOLS_SORT {

    label 'process_medium'
    conda 'envs/samtools_env.yml'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(name), path(bam)

    output:
    tuple val(name), path("${name}.sorted.bam")

    shell:
    """ 
    samtools sort -@ $task.cpus -o ${name}.sorted.bam $bam
    samtools index ${name}.sorted.bam
    """
}