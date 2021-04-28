#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

////////////////////////////////////////////////////
/* --          VALIDATE INPUTS                 -- */
////////////////////////////////////////////////////

if (params.public_data_ids) { 
    Channel
        .from(file(params.public_data_ids, checkIfExists: true))
        .splitCsv(header:false, sep:'', strip:true)
        .map { it[0] }
        .unique()
        .set { ch_public_data_ids }
} else { 
    exit 1, 'Input file with public database ids not specified!' 
}

////////////////////////////////////////////////////
/* --           CONFIGURE PARAMETERS           -- */
////////////////////////////////////////////////////

// Don't overwrite global params.modules, create a copy instead and use that within the main script.
def modules = params.modules.clone()

// sra_fastq_ftp
def sra_fastq_ftp_options = modules['sra_fastq_ftp']
sra_fastq_ftp_options.args = "-C - --max-time ${params.curl_max_time}"
sra_fastq_ftp_options.args2 = params.timeout_max_time

////////////////////////////////////////////////////
/* --    IMPORT LOCAL MODULES/SUBWORKFLOWS     -- */
////////////////////////////////////////////////////

include { SRA_IDS_TO_RUNINFO    } from './modules/sra_ids_to_runinfo'    addParams( options: modules['sra_ids_to_runinfo'] )
include { SRA_RUNINFO_TO_FTP    } from './modules/sra_runinfo_to_ftp'    addParams( options: modules['sra_runinfo_to_ftp'] )
include { SRA_FASTQ_FTP         } from './modules/sra_fastq_ftp'         addParams( options: sra_fastq_ftp_options         )

////////////////////////////////////////////////////
/* --           RUN MAIN WORKFLOW              -- */
////////////////////////////////////////////////////

workflow {

    /*
     * MODULE: Get SRA run information for public database ids
     */
    SRA_IDS_TO_RUNINFO (
        ch_public_data_ids
    )

    /*
     * MODULE: Parse SRA run information, create file containing FTP links and read into workflow as [ meta, [reads] ]
     */
    SRA_RUNINFO_TO_FTP (
        SRA_IDS_TO_RUNINFO.out.tsv
    )

    SRA_RUNINFO_TO_FTP
        .out
        .tsv
        .splitCsv(header:true, sep:'\t')
        .map { 
            meta -> 
                meta.single_end = meta.single_end.toBoolean()
                [ meta, [ meta.fastq_1, meta.fastq_2 ] ]
        }
        .set { ch_sra_reads }

    /*
    * MODULE: If FTP link is provided in run information then download FastQ directly via FTP and validate with md5sums
    */
    SRA_FASTQ_FTP (
        ch_sra_reads.map { meta, reads -> if (meta.fastq_1)  [ meta, reads ] }
    )
}

////////////////////////////////////////////////////
/* --                  THE END                 -- */
////////////////////////////////////////////////////

