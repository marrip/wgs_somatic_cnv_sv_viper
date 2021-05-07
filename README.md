# wgs_somatic_cnv_sv_viper

Workflow to call structural and copy number variants in somatic whole genome data

![Snakefmt](https://github.com/marrip/wgs_somatic_cnv_sv_viper/actions/workflows/main.yaml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## :speech_balloon: Introduction

This snakemake workflow produces `.vcf` files from `.bam` files.
More coming soon...

## :heavy_exclamation_mark: Dependencies

To run this workflow, the following tools need to be available:

![python](https://img.shields.io/badge/python-3.8-blue)

[![snakemake](https://img.shields.io/badge/snakemake-5.32.0-blue)](https://snakemake.readthedocs.io/en/stable/)

[![singularity](https://img.shields.io/badge/singularity-3.7-blue)](https://sylabs.io/docs/)

## :school_satchel: Preparations

### Sample data

1. Add all sample ids to `samples.tsv` in the column `sample`.
2. Use the `analysis_output` folder from [wgs_std_viper](https://github.com/marrip/wgs_std_viper)
as input.

### Reference data

1. You need a reference `.fasta` file to map your reads to. In addition, an index file is required.

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

2. This workflow is setup to filter the resulting `vcf` files from CNVnator,
Manta and TIDDIT. If this is undesired one could simply use an empty `bed` file
for filtering. Otherwise, the [SweGen database](https://swefreq.nbis.se/) is a
great resource as it contains specific `bed` files with normal variants for each
of the three tools. 
3. CNVkit requires a `cnn` file generated from a number of normal samples (at least
five) which acts as a panel of normals. It is recommended to preprocess them with
[wgs_std_viper](https://github.com/marrip/wgs_std_viper) to generate the `bam`
files. Subsequently, generate the PoN file like so:

```bash
cnvkit.py access path/to/reference.fasta -s 10000 -o access-10kb.reference.bed
cnvkit.py batch -n path/to/1.bam path/to/2.bam ... -m wgs --output-reference pon.cnn -f path/to/reference.fasta -g access-10kb.reference.bed
```

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
