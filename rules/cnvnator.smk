rule cnvnator:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}.bam",
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
