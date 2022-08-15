"""
Snakefile for downloading the Emu DB. Only need to run this once.

snakemake -c 1 -s DownloadDB.smk

"""

# instantiate the EMU_DB_DIR

if not os.path.exists(os.path.join(EMU_DB_DIR)):
    os.makedirs(os.path.join(EMU_DB_DIR))


rule all:
    input:
        db_output.append("DB/species_taxid.fasta")
        db_output.append("DB/names_df.tsv")
        db_output.append("DB/nodes_df.tsv")
        db_output.append("DB/unique_taxids.tsv")

rule get_db:
    params:
        emu_db = EMU_DB_DIR
    output:
        os.path.join(EMU_DB_DIR,"species_taxid.fasta"),
        os.path.join(EMU_DB_DIR,"names_df.tsv"),
        os.path.join(EMU_DB_DIR,"nodes_df.tsv"),
        os.path.join(EMU_DB_DIR,"unique_taxids.tsv")
    shell:
        """
        wget "https://gitlab.com/treangenlab/emu/-/archive/v1.0.1/emu-v1.0.1.tar.gz"
        mkdir -p {params.emu_db}
        tar -xf emu-v1.0.1.tar.gz -C {params.emu_db}
        mv {params.emu_db}/emu-v1.0.1/emu_database/* {params.emu_db}
        rm -rf {params.emu_db}/emu-v1.0.1
        rm emu-v1.0.1.tar.gz
        """


