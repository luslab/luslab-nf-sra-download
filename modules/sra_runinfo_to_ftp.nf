// Import generic module functions
include { saveFiles; getSoftwareName } from './functions'

params.options = [:]

/*
 * Create samplesheet for pipeline from SRA run information fetched via the ENA API
 */
process SRA_RUNINFO_TO_FTP {
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:[:], publish_by_meta:[]) }

    container "quay.io/biocontainers/python:3.8.3"
        
    input:
    path runinfo
    
    output:
    path "*.tsv", emit: tsv
    
    script:
    """
    $baseDir/bin/python/sra_runinfo_to_ftp.py ${runinfo.join(',')} ${runinfo.toString().tokenize(".")[0]}.runinfo_ftp.tsv
    """
}
