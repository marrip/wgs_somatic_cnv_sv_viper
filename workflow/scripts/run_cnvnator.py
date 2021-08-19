#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import subprocess

def run_cnvnator(bam, ref, root, out, log, param):
    logfile = open(log, "a+")
    logging.info("Extracting read mapping from bam/sam files")
    subprocess.call("cnvnator -root {root} -tree {bam}".format(root=root, bam=bam), stdout=logfile, stderr=logfile, shell=True)
    logging.info("Generating read depth histogram")
    subprocess.call("cnvnator -root {root} -his {param} -fasta {ref}".format(root=root, param=param, ref=ref), stdout=logfile, stderr=logfile, shell=True)
    logging.info("Calculating statistics")
    subprocess.call("cnvnator -root {root} -stat {param}".format(root=root, param=param), stdout=logfile, stderr=logfile, shell=True)
    logging.info("RD signal partitioning")
    subprocess.call("cnvnator -root {root} -partition {param}".format(root=root, param=param), stdout=logfile, stderr=logfile, shell=True)
    logging.info("CNV calling")
    outfile = open(out, "w+")
    subprocess.call("cnvnator -root {root} -call {param}".format(root=root, param=param), stdout=outfile, stderr=logfile, shell=True)
    outfile.close()
    logfile.close()

logging.basicConfig(level=logging.INFO, filename=snakemake.log[0])
run_cnvnator(snakemake.input["bam"], snakemake.input["ref"], snakemake.output["root"], snakemake.output["out"], snakemake.log[0], snakemake.params["bin"])
