rule cnvkit:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}_T.bam",
        pon=check_cnvkit_pon(),
    output:
        reg="analysis_output/{sample}/cnvkit/{sample}_T.cnr",
        seg="analysis_output/{sample}/cnvkit/{sample}_T.cns",
    log:
        "analysis_output/{sample}/cnvkit/cnvkit_{sample}.log",
    container:
        config["tools"]["cnvkit"]
    message:
        "{rule}: Run CNVkit on sample {wildcards.sample}_T"
    threads: 8
    shell:
        """
        cnvkit.py batch \
        {input.bam} \
        -r {input.pon} \
        -m wgs \
        -p {threads} \
        -d analysis_output/{wildcards.sample}/cnvkit/ &> {log}
        """


rule cnvkit2vcf:
    input:
        "analysis_output/{sample}/cnvkit/{sample}_T.cns",
    output:
        "analysis_output/{sample}/cnvkit/{sample}.vcf",
    log:
        "analysis_output/{sample}/cnvkit/cnvkit2vcf_{sample}.log",
    container:
        config["tools"]["cnvkit"]
    message:
        "{rule}: Convert CNVkit to vcf on sample {wildcards.sample}"
    threads: 8
    shell:
        """
        cnvkit.py export vcf \
        {input} \
        -i {wildcards.sample} \
        -o {output} &> {log}
        """
