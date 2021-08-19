rule cnvnator:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}_T.bam",
        ref=config["reference"]["fasta"],
    output:
        root="analysis_output/{sample}/cnvnator/{sample}.root",
        out="analysis_output/{sample}/cnvnator/{sample}.out",
    params:
        bin=1000,
    log:
        "analysis_output/{sample}/cnvnator/cnvnator_{sample}.log",
    container:
        config["tools"]["cnvnator"]
    message:
        "{rule}: Run CNVnator on sample {wildcards.sample}"
    script:
        "../scripts/run_cnvnator.py"


rule cnvnator2vcf:
    input:
        "analysis_output/{sample}/cnvnator/{sample}.out",
    output:
        "analysis_output/{sample}/cnvnator/{sample}.vcf",
    params:
        ref="GRCh38",
    log:
        "analysis_output/{sample}/cnvnator/cnvnator2vcf_{sample}.log",
    container:
        config["tools"]["cnvnator"]
    message:
        "{rule}: Generate vcf of {wildcards.sample} from CNVnator output"
    shell:
        """
        (cnvnator2VCF.pl \
        -prefix {wildcards.sample} \
        -reference {params.ref} \
        {input} &> {output}) 2> {log}
        """
