rule config_strelka:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}.bam",
        indel="analysis_output/{sample}/manta/results/variants/candidateSmallIndels.vcf.gz",
        ref=config["reference"]["fasta"],
    output:
        "analysis_output/{sample}/strelka/runWorkflow.py",
    log:
        "analysis_output/{sample}/strelka/config_strelka_{sample}.log",
    container:
        config["tools"]["strelka"]
    message:
        "{rule}: Generate Strelka run workflow script for {wildcards.sample}"
    shell:
        "configureStrelkaSomaticWorkflow.py "
        "--tumorBam {input.bam} "
        "--referenceFasta {input.ref} "
        "--indelCandidates {input.indel} "
        "--runDir analysis_output/{wildcards.sample}/strelka &> {log}"


rule strelka:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}.bam",
        indel="analysis_output/{sample}/manta/results/variants/candidateSmallIndels.vcf.gz",
        ref=config["reference"]["fasta"],
        script="analysis_output/{sample}/strelka/runWorkflow.py",
    output:
        "analysis_output/{sample}/strelka/results/variants/variants.vcf.gz",
        "analysis_output/{sample}/strelka/results/variants/variants.vcf.gz.tbi",
    log:
        "analysis_output/{sample}/strelka/strelka_{sample}.log",
    container:
        config["tools"]["strelka"]
    message:
        "{rule}: Call variants on {wildcards.sample} using Strelka"
    threads: 40
    shell:
        "{input.script} "
        "-j {threads} &> {log}"


rule prep_strelka_vcf:
    input:
        "analysis_output/{sample}/strelka/results/variants/variants.vcf.gz",
    output:
        "analysis_output/{sample}/strelka/{sample}.vcf",
    log:
        "analysis_output/{sample}/strelka/prep_strelka_vcf_{sample}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Copy and unzip strelka vcf"
    shell:
        "cp {input} {output}.gz &> {log} && "
        "gunzip {output}.gz &>> {log}"
