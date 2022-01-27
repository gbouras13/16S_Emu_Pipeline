### mamba env create -f emu_environment.yml
### mamba activate emu_env
### snakemake -s emu.smk --dag | dot -Tpng > dag.png
### mamba env update -f emu_environment.yaml
## snakemake -s emu.smk -c 16

import pandas as pd
import os
from snakemake.remote.HTTP import RemoteProvider as HTTPRemoteProvider

# https://stackoverflow.com/questions/66063221/does-snakemake-support-none-file-input

HTTP = HTTPRemoteProvider()
SAMPLES = pd.read_csv("metadata.csv").set_index("samples", drop=False)
EMU_DB_DIR = "DB"

db_output = list()

# https://stackoverflow.com/questions/66063221/does-snakemake-support-none-file-input
# https://stackoverflow.com/questions/64949149/is-it-possible-to-add-a-conditional-statement-in-snakemakes-rule-all

if os.path.isfile("DB/species_taxid.fasta") == False or os.path.isfile("DB/names_df.tsv") == False or os.path.isfile("DB/nodes_df.tsv") == False or  os.path.isfile("DB/unique_taxids.tsv") == False:
    db_output.append("DB/species_taxid.fasta")
    db_output.append("DB/names_df.tsv")
    db_output.append("DB/nodes_df.tsv")
    db_output.append("DB/unique_taxids.tsv")

rule all:
    input:
        db_output,
        abundance = expand('emu_results/{sample}_rel-abundance-threshold-0.01.tsv', sample = SAMPLES.index),
        read_counts = expand('emu_results/{sample}_readcount.txt', sample = SAMPLES.index),
        krona_input = expand('emu_results/{sample}_krona_input.txt', sample = SAMPLES.index),
        krona_output = expand('krona/{sample}_krona.html', sample = SAMPLES.index)

rule get_db:
    input:
        # Some file from the web
        url=HTTP.remote("https://gitlab.com/treangenlab/emu/-/archive/v1.0.1/emu-v1.0.1.tar.gz", keep_local=True)
    params:
        emu_db = EMU_DB_DIR
    output:
        directory("DB/"),
        "DB/species_taxid.fasta",
        "DB/names_df.tsv",
        "DB/nodes_df.tsv",
        "DB/unique_taxids.tsv"
    shell:
        """
        wget {input.url}
        mkdir -p {params.emu_db}
        tar -xf emu-v1.0.1.tar.gz -C {params.emu_db}
        mv {params.emu_db}/emu-v1.0.1/emu_database/* {params.emu_db}
        rm -rf {params.emu_db}/emu-v1.0.1
        """

rule emu:
    input:
        fastqs = 'fastqs/porechopped/{sample}.fastq.gz',
        taxids = "DB/species_taxid.fasta"
    params:
        emu_db = EMU_DB_DIR,
        out_dir = "emu_results",
        abundance = "0.01"
    output:
        abundance = 'emu_results/{sample}_rel-abundance-threshold-0.01.tsv'
    threads:
        workflow.cores * 0.9
    shell:
        '''
        emu abundance {input.fastqs} --threads {threads} --min-abundance {params.abundance} --db {params.emu_db} --output-dir {params.out_dir} --output-basename {wildcards.sample}
        '''

rule read_count:
    input:
        'fastqs/porechopped/{sample}.fastq.gz'
    output:
        reads = 'emu_results/{sample}_readcount.txt'

    shell:
        '''
        echo $(cat {input}|wc -l)/4|bc > {output}
        '''

rule krona_input:
    input:
        abundance = 'emu_results/{sample}_rel-abundance-threshold-0.01.tsv',
        reads = 'emu_results/{sample}_readcount.txt'

    output:
        reads = 'emu_results/{sample}_krona_input.txt'
    script:
        'Scripts/create_tsv_for_krona.py'

rule krona:
    input:
        'emu_results/{sample}_krona_input.txt'
    output:
        'krona/{sample}_krona.html'
    shell:
        '''
        ktImportText {input} -o {output}
        '''
