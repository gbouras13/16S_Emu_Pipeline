# 16S_Emu_Pipeline
Snakemake Pipeline to Taxonomically Classify Nanopore Long Read 16S Datasets using Emu

The only inputs required are:
1. Basecalled concatenated .fastq.gz files
2. A .csv file with metadata matching the fastq.gz file to the sample number.
3. an output directory specified

# Usage

1. Create and Activate the qc conda environment

```console
conda env create -f qc_environment.yaml
conda activate nanopore_qc_env
```

2. Run the qc.smk pipeline

```console
snakemake -s qc.smk -c {cores}
```
With 16 cores:
```console
snakemake -s qc.smk -c 16
```

# Output


* This will output fastqs in the fastqs/porechopped directory named for each sample. The fastqs have been filtered using filtlong (https://github.com/rrwick/Filtlong#acknowledgements) and had adapters and barcodes removed with porechop (https://github.com/rrwick/Porechop).
* It will also output summary qc plots and statistics in the Nanoplot directory.

3. Create and Activate the emu conda environment

```console
conda deactivate
conda env create -f emu_environment.yaml
conda activate emu_env
```

* Note that krona may ask you if you would like to specify a different directory where the taxabase will be saved - your choice.
* On the first installation, you will also need to run

```console
ktUpdateTaxonomy.sh
```

If this breaks(usually the download step), I have found that manually downloading the taxdump file from https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz and placing it in the appropriate directory, then running ktUpdateTaxonomy.sh again works.

4. Run the emu.smk pipeline

```console
snakemake -s emu.smk -c {cores}
```
With 16 cores:
```console
snakemake -s emu.smk -c 16
```

* This will run emu (https://gitlab.com/treangenlab/emu) on each sample, and will output tsvs with relative abundances "{sample}_rel-abundance.tsv" and "{sample}_rel-abundance-threshold-0.01.tsv" (in the emu_results directory).
* The script will also create Krona plots for each sample in the krona directory.
