#!/usr/bin/env nextflow

process BUSCO{
    label 'process_high'
    conda 'envs/busco_env.yml'
    publishDir "${params.outdir}/busco"

    input:
    tuple val(name), path(genome)
    
    output:
    path("BUSCO_${name}*"), emit: busco_out

    shell:
    """ 
    busco -i ${genome} -m genome --cpu $task.cpus -l alteromonas_odb12 -o BUSCO_${name}
    
    """

}