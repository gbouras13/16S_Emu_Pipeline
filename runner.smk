"""
The snakefile that runs the pipeline.
Manual launch example:


snakemake -c 16 -s runner.smk --use-conda     \
--config Input=/Users/a1667917/Documents/Staph_Plasmid/S_Aureus_07_07_Assembly_Output/PLASMIDS Output=/Users/a1667917/Documents/Staph_Plasmid/Gohar_PlasDB_Out



"""

import os

### DEFAULT CONFIGs
BigJobMem = 50000
SmallJobMem = 5000
BigJobCpu = 16
MIN_LENGTH = 1300
MAX_LENGTH = 1700
MIN_QUALITY = 8
EMU_DB_DIR = "Databases" # overrule this if required
MIN_ABUNDANCE = "0.001" # 0.1%

### DIRECTORIES
include: "rules/directories.smk"

# get if needed
INPUT_CSV = config['csv']
OUTPUT = config['Output']
# overwrite Emu DB
EMU_DB_DIR = config['Emu_DB']

# Parse the samples and read files
include: "rules/samples.smk"
dictReads = parseSamples(INPUT_CSV)
SAMPLES = list(dictReads.keys())
#print(SAMPLES)

# import targets
include: "rules/targets.smk"

# Import rules and functions
include: "rules/qc.smk"
include: "rules/emu.smk"

rule all:
    input:
        TargetFiles