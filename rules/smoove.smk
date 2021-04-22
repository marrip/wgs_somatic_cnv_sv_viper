rule smoove:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}.bam",
        ref=config["reference"]["fasta"],
        exc=config["smoove"]["exclude"],
    output:
        directory("analysis_output/{sample}/smoove/{sample}-lumpy-cmd.sh"),
    log:
        "analysis_output/{sample}/smoove/{sample}.log",
    container:
        config["tools"]["smoove"]
    message:
        "{rule}: Call variants on {wildcards.sample} using smoove"
    threads: 40
    shell:
        "smoove call "
        "-x "
        "--name {wildcards.sample} "
        "--exclude {input.exc} "
        "--fasta {input.ref} "
        "--genotype {input.bam} "
        "-p {threads} "
        "-o analysis_output/{wildcards.sample}/smoove &> {log}"
