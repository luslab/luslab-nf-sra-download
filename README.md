# Luslab Data Downloader

This pipeline extended the functionality of the nf-core DSL2 SRA downloader by providing more robust error tollerance to the weird download errors that are often recieved from GEO. The probary one being transfer rate dropping to zero during download but no fail or connection issues.

To run:

```
nextflow run luslab/luslab-nf-sra-download -profile docker --public_data_ids {FILE WITH LIST OF IDS FOR DOWNLOAD (ONE ID PER LINE)} --curl_max_time 600 --timeout_max_time 12h
```

- `--curl_max_time`    -- The max time in seconds before the download is restarted. Decrease for more patchy downloads and Increase for more stable one. defaults to 600
- `--timeout_max_time` -- The max time in `m/h` that a download will run for before failing. Increase for larger downloads, you should not need to decrease it. defaults to 12h

Supported ids:

```
## Example ids supported by this script
SRA_IDS = ['PRJNA63463', 'SAMN00765663', 'SRA023522', 'SRP003255', 'SRR390278', 'SRS282569', 'SRX111814']
ENA_IDS = ['ERA2421642', 'ERP120836', 'ERR674736', 'ERS4399631', 'ERX629702', 'PRJEB7743', 'SAMEA3121481']
GEO_IDS = ['GSE18729', 'GSM465244']
```
## Running on CAMP

Create a `run.sh` file with the code below in and change your parameters accordingly

```#!/bin/sh

export NXF_SINGULARITY_CACHEDIR=/camp/lab/luscomben/home/shared/singularity

## LOAD REQUIRED MODULES
ml purge
ml Nextflow/20.12.0-edge
ml Singularity/3.4.2
ml Graphviz

## UPDATE PIPLINE
nextflow pull luslab/luslab-nf-sra-download

## RUN PIPELINE
nextflow run luslab/luslab-nf-sra-download \
  -profile crick \
  -r main \
  --public_data_ids em-seq-200ng.txt \
  --curl_max_time 1200 \
  --timeout_max_time 2h \
  -resume
  ```
