// Import generic module functions
include { saveFiles; getSoftwareName } from './functions'

params.options = [:]

/*
 * Fetch SRA / ENA / GEO run information via the ENA API
 */
process SRA_IDS_TO_RUNINFO {
    tag "$id"
    label 'error_retry'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:[:], publish_by_meta:[]) }

    container "quay.io/biocontainers/requests:2.24.0"
    
    input:
    val id
    
    output:
    path "*.tsv", emit: tsv
    
    script:
    """
    echo $id > id.txt
    $baseDir/bin/python/sra_ids_to_runinfo.py id.txt ${id}.runinfo.tsv
    """
}
