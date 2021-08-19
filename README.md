# wgs_somatic_cnv_sv_viper

Workflow to call structural and copy number variants in somatic whole genome data

![Snakefmt](https://github.com/marrip/wgs_somatic_cnv_sv_viper/actions/workflows/main.yaml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## :speech_balloon: Introduction

This snakemake workflow takes `.bam` files, which were prepped according to
[GATK best practices](https://gatk.broadinstitute.org/hc/en-us/articles/360035535912-Data-pre-processing-for-variant-discovery),
and calls CNVs and SVs. The workflow can process tumor samples
paired with normals or be run as a tumor-only analysis.

### CNVkit

This tool is best used with a panel of normals (PoN) which should be generated
according to the
[docs](https://cnvkit.readthedocs.io/en/stable/pipeline.html#reference).

### CNVnator

CNVnator runs tumor only according to the docs in the
[repo](https://github.com/abyzovlab/CNVnator).

### Manta

Manta can be run in tumor only or tumor/normal mode. Please refer to the
[docs](https://github.com/Illumina/manta/blob/master/docs/userGuide/README.md).

### TIDDIT

The tool is running tumor only as described in the
[repo](https://github.com/SciLifeLab/TIDDIT).

## :heavy_exclamation_mark: Dependencies

To run this workflow, the following tools need to be available:

![python](https://img.shields.io/badge/python-3.8-blue)
[![snakemake](https://img.shields.io/badge/snakemake-6.0.0-blue)](https://snakemake.readthedocs.io/en/stable/)
[![singularity](https://img.shields.io/badge/singularity-3.7-blue)](https://sylabs.io/docs/)

## :school_satchel: Preparations

### Sample data

1. Add all sample ids to `samples.tsv` in the column `sample`.
2. Add sample type information, normal or tumor, to `units.tsv`.
3. Use the `analysis_output` folder from
[wgs_std_viper](https://github.com/marrip/wgs_std_viper) as input.
4. If a PoN was not created earlier, use the  `analysis_output`
folder from
[wgs_somatic_pon](https://github.com/marrip/wgs_somatic_pon) as input.
as input.

### Reference data

1. You need a reference `.fasta` file representing the genome used
for mapping. In addition, an index file is required.

- The required files for the human reference genome GRCh38 can be downloaded from
[google cloud](https://console.cloud.google.com/storage/browser/genomics-public-data/resources/broad/hg38/v0).
The download can be manually done using the browser or using `gsutil` via the command line:

```bash
gsutil cp gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta /path/to/download/dir/
```

- If those resources are not available for your reference you may generate them yourself:

```bash
samtools faidx /path/to/reference.fasta
```

3. CNVkit requires a panel of normals (PoN) which should be supplied. If you do not
have a PoN you can simply leave `""` instead to link the workflow to the output
from [wgs_somatic_pon](https://github.com/marrip/wgs_somatic_pon).
3. This workflow is setup to filter the resulting `.vcf` files from CNVnator,
Manta and TIDDIT. If this is undesired one could simply use an empty `.bed` file
for filtering. Otherwise, the [SweGen database](https://swefreq.nbis.se/) is a
great resource as it contains specific `.bed` files with normal variants for each
of the three tools. 
4. Add the paths of the different files to the `config.yaml`. The index file should be
in the same directory as the reference `.fasta`.
5. Make sure that the docker container versions are correct.

## :white_check_mark: Testing

The workflow repository contains a small test dataset `.tests/integration` which can be run like so:

```bash
cd .tests/integration
snakemake -s ../../Snakefile -j1 --use-singularity
```

## :rocket: Usage

The workflow is designed for WGS data meaning huge datasets which require a lot of compute power. For
HPC clusters, it is recommended to use a cluster profile and run something like:

```bash
snakemake -s /path/to/Snakefile --profile my-awesome-profile
```

## :judge: Rule Graph

![rule_graph](https://raw.githubusercontent.com/marrip/wgs_somatic_cnv_sv_viper/main/images/rulegraph.svg)
