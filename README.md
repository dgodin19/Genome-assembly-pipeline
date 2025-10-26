# Bacterial Genome Assembly and Annotation Pipeline

This Nextflow pipeline automates assembly, polishing, annotation, and quality assessment of bacterial genomes using both long and short read data. The workflow integrates raw data quality control, genome assembly, read alignment, polishing, annotation, and evaluation against a reference genome.

# Modules Used

The pipeline utilizes the following modules, found in the modules folder:

    FASTQC: Quality control for short read data
    FILTLONGER: Filtering long reads
    FLYE: Long read genome assembly
    BOWTIE2_INDEX: Indexing for short read alignment
    BOWTIE2_ALIGN: Aligning short reads to assemblies
    SAMTOOLS_SORT: Sorting and indexing alignments
    PILON: Genome polishing using aligned short reads
    PROKKA: Genome annotation
    BUSCO: Genome completeness assessment
    BUSCO_PLOT: Visualization of BUSCO results
    NCBI_DATASETS: Downloading reference genomes
    QUAST & QUAST_UNPOLISHED: Assembly quality evaluation (for polished and unpolished assemblies)

# Folder Structure

    main.nf: The central Nextflow pipeline script.
    modules/: Contains all process definitions as separate modules.

