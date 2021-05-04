include: "rules/common.smk"
include: "rules/cnvnator.smk"
include: "rules/manta.smk"
include: "rules/filter_vcf.smk"
include: "rules/strelka.smk"
include: "rules/tiddit.smk"


rule all:
    input:
        expand(
            "analysis_output/{sample}/wgs_somatic_cnv_sv_viper.ok", sample=samples.index
        ),


rule workflow_complete:
    input:
        unpack(compile_output_list),
    output:
        "analysis_output/{sample}/wgs_somatic_cnv_sv_viper.ok",
    log:
        "analysis_output/{sample}/wgs_somatic_cnv_sv_viper.workflow_complete.log",
    container:
        config["tools"]["common"]
    shell:
        "touch {output} &> {log}"
