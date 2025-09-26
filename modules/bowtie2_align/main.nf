#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    conda 'envs/bowtie2_env.yml'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(name), path(short1), path(short2)
    tuple val(name), val(idxBase), path(indexDir)

    output:
    tuple val(name), path("${name}.bam")

    shell:
    """ 
    bowtie2 -x ${indexDir}/${idxBase} -1 $short1 -2 $short2 | samtools view -bS - > ${name}.bam
    """

}