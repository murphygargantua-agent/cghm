#!/usr/bin/env nextflow
/**
 * Meta-module entry point for the `allelic-distribution` nf-core module.
 */
include {
    ALLELIC_DISTRIBUTION
} from "./main.nf"

module {
    name: "cghm::allelic-distribution"
    version: "1.0.0"
    license: "MIT"
    description: "cgMLST allelic distribution analysis for Chlamydia trachomatis"
    authors: [
        module_author("Murphy", "murphy@example.com")
    ]
    references: [
        module_reference("Lohdia et al.", "2025", "Advancing Chlamydia trachomatis genomic surveillance and research with a novel core-genome MLST approach")
    ]
}
