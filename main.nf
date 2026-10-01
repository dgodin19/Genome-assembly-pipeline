include {FASTQC} from './modules/fastqc'
include {FILTLONGER} from './modules/filtlonger'
include {FLYE} from './modules/flye'
include {BOWTIE2_INDEX} from './modules/bowtie2_index'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_SORT} from './modules/samtools'
include {PILON} from './modules/pilon'
include {BUSCO} from './modules/busco'
include {NCBI_DATASETS} from './modules/ncbi_datasets_cli'
include {QUAST} from './modules/quast'
include {QUAST as QUAST_UNPOLISHED} from './modules/quast'
include {PROKKA} from './modules/prokka'
include {BUSCO_PLOT} from './modules/busco_plot'

workflow {

    Channel.fromPath(params.bac_samples)
    | splitCsv(header: true)
    | map { row -> tuple(row.name, file(row.nano))}
    | set { longread_ch }

    Channel.fromPath(params.bac_samples)
    | splitCsv(header: true)
    | map { row -> tuple(row.name, file(row.short1), file(row.short2))}
    | set { shortread_ch }

    // Run QC on the short reads
    FASTQC(shortread_ch)

    // Filter the long reads
    FILTLONGER(longread_ch)

    // Pass the filtered reads to the assembly tool
    FLYE(FILTLONGER.out)


    //Align Short Reads For Polishing

    // Create an index of the assembly
    BOWTIE2_INDEX(FLYE.out)

    // Align the short reads to the assembly
    BOWTIE2_ALIGN(FASTQC.out.reads, BOWTIE2_INDEX.out)
    
    // Sort and index the alignments
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out)

    // Short Read Polishing using the alignments
    PILON(FLYE.out, SAMTOOLS_SORT.out)

    PROKKA(PILON.out)

    // Run BUSCO on the Polished Assembly
    BUSCO(PILON.out)

    // Download the canonical reference genome 
    NCBI_DATASETS(params.ref_genome)

    ref_ch = NCBI_DATASETS.out

    // Run QUAST comparing the final assembly with the reference genome
    PILON.out
    .combine(ref_ch)
    .map { name, genome, ref -> tuple(name, genome, "polished", ref) }
    | QUAST

    // Run QUAST on the unpolished assembly
    FLYE.out
    .combine(ref_ch)
    .map { name, genome, ref -> tuple(name, genome, "unpolished", ref) }
    | QUAST_UNPOLISHED

    // Run BUSCO PLOT on the BUSCO output
    BUSCO_PLOT(BUSCO.out.busco_out)
    
}
