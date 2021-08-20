import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

min_version("6.0.0")

### Set and validate config file


configfile: "config.yaml"


validate(config, schema="../schemas/config.schema.yaml")


### Read and validate samples file

samples = pd.read_table(config["samples"], dtype=str).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")


### Read and validate units file

units = (
    pd.read_table(config["units"], dtype=str)
    .sort_values(["sample", "unit"], ascending=False)
    .set_index(["sample", "unit", "run", "lane"], drop=False)
)
validate(units, schema="../schemas/units.schema.yaml")


### Generate modus dictionary

modus = units.drop_duplicates().groupby("sample").unit
modus = pd.concat([modus.apply("".join)], axis=1, keys=["modus"]).to_dict()["modus"]


### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),


### Functions


def check_cnvkit_pon():
    if config["cnvkit"]["pon"] == "":
        return "analysis_output/pon/cnvkit_somatic_pon.cnn"
    else:
        return config["cnvkit"]["pon"]


def get_bam(wildcards):
    if modus[wildcards.sample] == "TN":
        return {
            "t_bam": "analysis_output/{sample}/gather_bam_files/{sample}_T.bam".format(
                sample=wildcards.sample
            ),
            "n_bam": "analysis_output/{sample}/gather_bam_files/{sample}_N.bam".format(
                sample=wildcards.sample
            ),
        }
    elif modus[wildcards.sample] == "T":
        return {
            "t_bam": "analysis_output/{sample}/gather_bam_files/{sample}_T.bam".format(
                sample=wildcards.sample
            ),
        }
    else:
        raise WorkflowError("%s is not paired with a tumor sample" % wildcards.sample)


def get_manta_fmt_input(wildcards):
    files = get_bam(wildcards)
    if modus[wildcards.sample] == "TN":
        return "%s --normalBam=%s" % (
            files["t_bam"],
            files["n_bam"],
        )
    else:
        return files["t_bam"]


def get_manta_vcf(wildcards):
    if modus[wildcards.sample] == "TN":
        return (
            "analysis_output/%s/manta/results/variants/somaticSV.vcf.gz"
            % wildcards.sample
        )
    else:
        return (
            "analysis_output/%s/manta/results/variants/tumorSV.vcf.gz"
            % wildcards.sample
        )


def compile_output_list(wildcards):
    output_list = []
    files = {
        "cnvkit": ["vcf"],
        "cnvnator": [
            "pon.vcf",
        ],
        "manta": [
            "pon.vcf",
        ],
        "tiddit": [
            "pon.vcf",
        ],
    }
    for key in files.keys():
        output_list = output_list + expand(
            "analysis_output/{sample}/{tool}/{sample}.{ext}",
            sample=samples.index,
            tool=key,
            ext=files[key],
        )
    return output_list
