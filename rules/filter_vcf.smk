rule pon_filter_vcf:
    input:
        vcf="analysis_output/{sample}/{tool}/{sample}.vcf",
        bed=lambda wildcards: config[wildcards.tool]["pon"],
    output:
        "analysis_output/{sample}/{tool}/{sample}.pon.vcf",
    log:
        "analysis_output/{sample}/{tool}/pon_filter_vcf_{sample}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter {wildcards.sample} vcf using {input.bed}"
    shell:
        "(bedtools intersect "
        "-v "
        "-header "
        "-f 0.95 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"
