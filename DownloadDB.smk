"""
Snakefile for downloading the Emu DB. Only need to run this once.

snakemake -c 1 -s DownloadDB.smk --config EMU_DB_DIR=DB

"""

# instantiate the EMU_DB_DIR

EMU_DB_DIR="DB"

if not os.path.exists(os.path.join(EMU_DB_DIR)):
    os.makedirs(os.path.join(EMU_DB_DIR))


rule all:
    input:
        os.path.join(EMU_DB_DIR,"taxonomy.tsv"),
        os.path.join(EMU_DB_DIR,"species_taxid.fasta")

rule get_db:
    params:
        emu_db = EMU_DB_DIR
    output:
        os.path.join(EMU_DB_DIR,"taxonomy.tsv"),
        os.path.join(EMU_DB_DIR,"species_taxid.fasta")
    shell:
        """
        wget "https://gitlab.com/treangenlab/emu/-/archive/v3.0.0/emu-v3.0.0.tar.gz"
        mkdir -p {params.emu_db}
        tar -xf emu-v3.0.0.tar.gz -C {params.emu_db}
        mv {params.emu_db}/emu-v3.0.0/emu_database/* {params.emu_db}
        rm -rf {params.emu_db}/emu-v3.0.0
        rm emu-v3.0.0.tar.gz
        """


