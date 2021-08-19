rule config_manta:
    input:
        unpack(get_bam),
        ref=config["reference"]["fasta"],
    output:
        "analysis_output/{sample}/manta/runWorkflow.py",
    params:
        get_manta_fmt_input,
    log:
        "analysis_output/{sample}/manta/config_manta_{sample}.log",
    container:
        config["tools"]["manta"]
    message:
        "{rule}: Generate Manta run workflow script for {wildcards.sample}"
    shell:
        """
        configManta.py \
        --tumorBam={params} \
        --referenceFasta={input.ref} \
        --runDir=analysis_output/{wildcards.sample}/manta &> {log}
        """


rule manta_TN:
    input:
        unpack(get_bam),
        ref=config["reference"]["fasta"],
        script="analysis_output/{sample}/manta/runWorkflow.py",
    output:
        "analysis_output/{sample}/manta/results/variants/candidateSmallIndels.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/candidateSmallIndels.vcf.gz.tbi",
        "analysis_output/{sample}/manta/results/variants/candidateSV.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/candidateSV.vcf.gz.tbi",
        "analysis_output/{sample}/manta/results/variants/diploidSV.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/diploidSV.vcf.gz.tbi",
        "analysis_output/{sample}/manta/results/variants/somaticSV.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/somaticSV.vcf.gz.tbi",
        temp(directory("analysis_output/{sample}/manta/workspace")),
    log:
        "analysis_output/{sample}/manta/manta_{sample}_TN.log",
    container:
        config["tools"]["manta"]
    message:
        "{rule}: Call variants on {wildcards.sample} using Manta"
    threads: 40
    shell:
        """
        {input.script} \
        -j {threads} \
        -g unlimited &> {log}
        """


rule manta_T:
    input:
        unpack(get_bam),
        ref=config["reference"]["fasta"],
        script="analysis_output/{sample}/manta/runWorkflow.py",
    output:
        "analysis_output/{sample}/manta/results/variants/candidateSmallIndels.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/candidateSmallIndels.vcf.gz.tbi",
        "analysis_output/{sample}/manta/results/variants/candidateSV.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/candidateSV.vcf.gz.tbi",
        "analysis_output/{sample}/manta/results/variants/tumorSV.vcf.gz",
        "analysis_output/{sample}/manta/results/variants/tumorSV.vcf.gz.tbi",
        temp(directory("analysis_output/{sample}/manta/workspace")),
    log:
        "analysis_output/{sample}/manta/manta_{sample}_T.log",
    container:
        config["tools"]["manta"]
    message:
        "{rule}: Call variants on {wildcards.sample} using Manta"
    threads: 40
    shell:
        """
        {input.script} \
        -j {threads} \
        -g unlimited &> {log}
        """


rule prep_manta_vcf:
    input:
        get_manta_vcf,
    output:
        "analysis_output/{sample}/manta/{sample}.vcf",
    log:
        "analysis_output/{sample}/manta/prep_manta_vcf_{sample}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Copy and unzip manta vcf"
    shell:
        """
        cp {input} {output}.gz &> {log} && \
        gunzip {output}.gz &>> {log}
        """
