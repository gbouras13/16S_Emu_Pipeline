rule emu:
    input:
        fastqs = os.path.join(TMP,"{sample}_filtlong.fastq.gz")
    params:
        db = EMU_DB_DIR,
        out_dir = os.path.join(EMU,"{sample}"),
        min_abundance = MIN_ABUNDANCE
    output:
        abundance = os.path.join(EMU,"{sample}",'{sample}_rel-abundance.tsv')
    threads:
        BigJobCpu
    resources:
        mem_mb=BigJobMem
    conda:
        os.path.join('..', 'envs','emu.yaml')
    shell:
        '''
        emu abundance {input.fastqs} --threads {threads} --min-abundance {params.min_abundance} --db {params.db} --output-dir {params.out_dir} --output-basename {wildcards.sample}
        '''

rule read_count:
    input:
        os.path.join(TMP,"{sample}_filtlong.fastq.gz")
    output:
        os.path.join(EMU,"{sample}",'{sample}_readcount.txt')
    shell:
        '''
        echo $(cat {input}|wc -l)/4|bc > {output}
        '''

rule krona_input:
    input:
        abundance = os.path.join(EMU,"{sample}",'{sample}_rel-abundance.tsv'),
        reads = os.path.join(EMU,"{sample}",'{sample}_readcount.txt')
    output:
        reads = os.path.join(EMU,"{sample}",'{sample}_krona_input.txt')
    conda:
        os.path.join('..', 'envs','emu.yaml')
    script:
        'Scripts/create_tsv_for_krona.py'

rule krona:
    input:
        os.path.join(EMU,"{sample}",'{sample}_krona_input.txt')
    output:
        os.path.join(KRONA,'{sample}_krona.html')
    conda:
        os.path.join('..', 'envs','emu.yaml')
    shell:
        '''
        ktImportText {input} -o {output}
        '''

rule aggr_emu:
    input:
        expand(os.path.join(EMU,"{sample}",'{sample}_rel-abundance.tsv'), sample = SAMPLES),
        expand(os.path.join(KRONA,'{sample}_krona.html'), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_emu.txt")
    threads:
        1
    resources:
        mem_mb=SmallJobMem
    shell:
        """
        touch {output[0]}
        """