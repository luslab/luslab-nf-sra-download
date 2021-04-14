process STRING_SPLIT {

    container "biocontainers/biocontainers:v1.2.0_cv1" 

    input:
    path input

    output:
    path "*", emit: files

    script:
    """
    awk '{f="file" NR; print \$0 ","> f}' RS=',' $input
    """
}