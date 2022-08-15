#!/bin/bash -l

#SBATCH --job-name=16S_Kenny_31_05
#SBATCH --mail-user=george.bouras@adelaide.edu.au
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --err="16S_Kenny_31_05_snk.err"
#SBATCH --output="16S_Kenny_31_05_snk.out"

# Resources allocation request parameters
#SBATCH -p batch
#SBATCH -N 1                                                    # number of tasks (sequential job starts 1 task) (check this if your job unexpectedly uses 2 nodes)
#SBATCH -c 1                                                    # number of cores (sequential job calls a multi-thread program that uses 8 cores)
#SBATCH --time=23:00:00                                         # time allocation, which has the format (D-HH:MM), here set to 1 hou                                           # generic resource required (here requires 1 GPUs)
#SBATCH --mem=1GB                                              # specify memory required per node


SNK_DIR="/hpcfs/users/a1667917/16S_Emu_Pipeline"
PROF_DIR="/hpcfs/users/a1667917/snakemake_slurm_profile"

cd $SNK_DIR

module load Anaconda3/2020.07
conda activate snakemake_clean_env

snakemake -c 1 -s runner.smk --use-conda --profile $PROF_DIR/bact_assembly --conda-frontend conda \
--config csv=kenny_31_05_metadata.csv Output=/hpcfs/users/a1667917/Kenny/31_05_Output Emu_DB=/hpcfs/users/a1667917/Emu_DB

# snakemake -c 1 -s runner.smk --use-conda --conda-frontend conda --conda-create-envs-only \
# --config csv=kenny_31_05_metadata.csv Output=/hpcfs/users/a1667917/Kenny/31_05_Output Emu_DB=/hpcfs/users/a1667917/Emu_DB


conda deactivate