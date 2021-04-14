process FILE_MERGE {

    container "biocontainers/biocontainers:v1.2.0_cv1" 

    input:
    path input

    output:
    path "*.txt", emit: file

    script:
    """
    cat * > merged.txt
    """
}