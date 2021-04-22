rule config_manta:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}.bam",
        ref=config["reference"]["fasta"],
    output:
        "analysis_output/{sample}/manta/runWorkflow.py",
    log:
        "analysis_output/{sample}/manta/config_manta_{sample}.log",
    container:
        config["tools"]["manta"]
    message:
        "{rule}: Generate Manta run workflow script for {wildcards.sample}"
    shell:
        "configManta.py "
        "--tumorBam={input.bam} "
        "--referenceFasta={input.ref} "
        "--runDir=analysis_output/{wildcards.sample}/manta &> {log}"


rule manta:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}.bam",
        ref=config["reference"]["fasta"],
        script="analysis_output/{sample}/manta/runWorkflow.py",
    output:
        "analysis_output/{sample}/manta/results/variants/candidateSmallIndels.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/candidateSmallIndels.vcf.gz.tbi",
        "analysis_output/{sample}/manta/results/variants/candidateSV.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/candidateSV.vcf.gz.tbi",
        "analysis_output/{sample}/manta/results/variants/tumorSV.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/tumorSV.vcf.gz.tbi",
    log:
        "analysis_output/{sample}/manta/manta_{sample}.log",
    container:
        config["tools"]["manta"]
    message:
        "{rule}: Call variants on {wildcards.sample} using Manta"
    threads: 40
    shell:
        "{input.script} "
        "-j {threads} "
        "-g unlimited &> {log}"


rule prep_manta_vcf:
    input:
        "analysis_output/{sample}/manta/results/variants/tumorSV.vcf.gz",
    output:
        "analysis_output/{sample}/manta/{sample}.vcf",
    log:
        "analysis_output/{sample}/manta/prep_manta_vcf_{sample}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Copy and unzip manta vcf"
    shell:
        "cp {input} {output}.gz &> {log} && "
        "gunzip {output}.gz &>> {log}"
