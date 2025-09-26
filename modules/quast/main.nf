#!/usr/bin/env nextflow

process QUAST {
    label 'process_medium'
    conda 'envs/quast_env.yml'
    publishDir "${params.outdir}/quast"

    input:
    tuple val(name), path(genome), val(tag), path(ref_genome)

    output:
    path("QUAST_${name}_${tag}/")

    shell:
    """
    quast.py -t $task.cpus -r $ref_genome -o QUAST_${name}_${tag} $genome
    """
}