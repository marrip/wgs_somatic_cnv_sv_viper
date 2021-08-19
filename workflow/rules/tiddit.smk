rule tiddit:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}_T.bam",
        ref=config["reference"]["fasta"],
    output:
        "analysis_output/{sample}/tiddit/{sample}.gc.wig",
        "analysis_output/{sample}/tiddit/{sample}.ploidy.tab",
        "analysis_output/{sample}/tiddit/{sample}.sample.bam",
        "analysis_output/{sample}/tiddit/{sample}.signals.tab",
        "analysis_output/{sample}/tiddit/{sample}.vcf",
        "analysis_output/{sample}/tiddit/{sample}.wig",
    log:
        "analysis_output/{sample}/tiddit/{sample}.log",
    container:
        config["tools"]["tiddit"]
    message:
        "{rule}: Run TIDDIT on sample {wildcards.sample}"
    shell:
        """
        TIDDIT.py \
        --sv \
        --bam {input.bam} \
        --ref {input.ref} \
        -o analysis_output/{wildcards.sample}/tiddit/{wildcards.sample} &> {log}
        """
