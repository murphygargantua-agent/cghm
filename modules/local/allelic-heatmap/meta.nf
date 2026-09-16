#!/usr/bin/env nextflow
/**
 * Meta-module entry point for the `allelic-heatmap` nf-core module.
 *
 * Defines the module's parameters, channels, and process.  This file is
 * imported by the pipeline workflow via `module` declarations.
 */
include {
    allelic_heatmap
} from "./main.nf"

module {
    name: "cghm::allelic-heatmap"
    version: "1.0.0"
    license: "MIT"
    authors: [
        module_author("Murphy", "murphy@example.com")
    ]
    homepage: "https://github.com/insapathogenomics/allelic_diversity"
    description: "cgMLST allelic heatmap generation for Chlamydia trachomatis"
    references: [
        module_reference("Lohdia et al.", "2025", "Advancing Chlamydia trachomatis genomic surveillance and research with a novel core-genome MLST approach")
    ]
}
