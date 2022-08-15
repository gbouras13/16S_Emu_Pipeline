# 16S_Emu_Pipeline
Snakemake Pipeline to Taxonomically Classify Nanopore Long Read 16S Datasets using Emu

The only inputs required are:
1. Basecalled concatenated .fastq.gz files
2. A .csv file with metadata matching the fastq.gz file to the sample number.
3. an output directory specified
4. Emu B specified.

# Usage

```console
snakemake -c <cores> -s runner.smk --use-conda  --conda-frontend conda \
--config csv=<metadata> Output=<output dir> EMU_DB_DIR=<Emu DB Dir>
```

You will need to download the EMu DB first:

```console
snakemake -c 1 -s DownloadDB.smk --config EMU_DB_DIR=DB
```



# Output

* Summary qc plots and statistics in the Nanoplot directory.
* tsvs with relative abundances "{sample}_rel-abundance.tsv" and "{sample}_rel-abundance-threshold-0.01.tsv" (in the emu_results directory).
*  Krona plots for each sample in the krona directory.
