# wgs_somatic_cnv_sv_viper

Workflow to call structural and copy number variants in somatic whole genome data

![Snakefmt](https://github.com/marrip/wgs_somatic_cnv_sv_viper/actions/workflows/main.yaml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## :speech_balloon: Introduction

This snakemake workflow produces `.vcf` files from `.bam` files.
More coming soon...

## :heavy_exclamation_mark: Dependencies

To run this workflow, the following tools need to be available:

1. python ≥ 3.8
2. [snakemake](https://snakemake.readthedocs.io/en/stable/) ≥ 5.32.0
3. [Singularity](https://sylabs.io/docs/) ≥ 3.7

## :school_satchel: Preparations

### Sample data

1. Add all sample ids to `samples.tsv` in the column `sample`.
2. Use the `analysis_output` folder from [wgs_std_viper](https://github.com/marrip/wgs_std_viper)
as input.

### Reference data

Coming soon...

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
