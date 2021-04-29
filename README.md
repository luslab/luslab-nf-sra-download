# Luslab Data Downloader

This pipeline extended the functionality of the nf-core DSL2 SRA downloader by providing more robust error tollerance to the weird download errors that are often recieved from GEO. The probary one being transfer rate dropping to zero during download but no fail or connection issues.

To run:

```
nextflow run luslab/luslab-nf-sra-download -profile docker --public_data_ids {FILE WITH LIST OF IDS FOR DOWNLOAD} --curl_max_time 1200 --timeout_max_time 2h
```

Supported ids:

```
## Example ids supported by this script
SRA_IDS = ['PRJNA63463', 'SAMN00765663', 'SRA023522', 'SRP003255', 'SRR390278', 'SRS282569', 'SRX111814']
ENA_IDS = ['ERA2421642', 'ERP120836', 'ERR674736', 'ERS4399631', 'ERX629702', 'PRJEB7743', 'SAMEA3121481']
GEO_IDS = ['GSE18729', 'GSM465244']
```
