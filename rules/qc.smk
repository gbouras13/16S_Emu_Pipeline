def get_input_fastqs(wildcards):
    return dictReads[wildcards.sample]["LR"]

rule filtlong:
    input:
        get_input_fastqs
    output:
        os.path.join(TMP,"{sample}_filtlong.fastq.gz")
    params:
        min_read_size = MIN_LENGTH,
        max_read_size = MAX_LENGTH,
        max_q_score = MIN_QUALITY
    resources:
        mem_mb=SmallJobMem
    conda:
        os.path.join('..', 'envs','qc.yaml')
    threads:
        1
    shell:
        '''
        filtlong --min_length {params.min_read_size} --max_length {params.max_read_size} --min_mean_q {params.keep_percent} {input} | gzip > {output}
        rm {input}
        '''

rule nanoplot:
    input:
        os.path.join(TMP,"{sample}_filtlong.fastq.gz")
    output:
        directory(os.path.join(NANOPLOT,"{sample}"))
    resources:
        mem_mb=SmallJobMem
    conda:
        os.path.join('..', 'envs','qc.yaml')
    threads:
        BigJobCpu
    shell:
        'NanoPlot --prefix pass --fastq {input} -t {threads} -o {output}'

    
rule aggr_qc:
    input:
        expand( os.path.join(TMP,"{sample}_filtlong.fastq.gz"), sample = SAMPLES),
        expand( directory(os.path.join(NANOPLOT,"{sample}")), sample = SAMPLES)
    output:
        os.path.join(LOGS, "aggr_qc.txt")
    threads:
        1
    resources:
        mem_mb=SmallJobMem
    shell:
        """
        touch {output[0]}
        """
