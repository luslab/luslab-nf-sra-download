process HELLO {

    container "biocontainers/biocontainers:v1.2.0_cv1" 

    script:
    """
    echo "Hello World"
    """
}