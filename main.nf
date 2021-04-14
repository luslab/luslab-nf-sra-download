#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//log.info "Hello World"

include { HELLO } from './modules/software/linux/hello'

workflow {

    HELLO()
}