#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

ch_input = Channel.fromPath( "$projectDir/data/input.txt", checkIfExists: true )

//log.info "Hello World"

//include { HELLO } from './modules/software/linux/hello'
include { STRING_SPLIT } from './modules/software/linux/string_split'
include { FILE_MERGE } from './modules/software/linux/file_merge'

workflow {
    
    //ch_input | view
    STRING_SPLIT(ch_input)
    //STRING_SPLIT.out.files.flatten() | view 

    FILE_MERGE(STRING_SPLIT.out.files.flatten())
}