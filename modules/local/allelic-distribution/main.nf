#!/usr/bin/env nextflow
/**
 * cgMLST allelic-distribution module.
 *
 * Wraps the Lohdia et al. (2025) `allelic_distribution.py` script from
 * https://github.com/insapathogenomics/allelic_diversity (v1.0.0).
 * Produces per-group allele proportions and per-locus allele distribution.
 *
 * Inputs:
 *   - allele_matrix: cgMLST allele matrix TSV (samples x loci)
 *   - metadata: sample metadata TSV (samples x columns)
 *   - group_column: metadata column defining the groups (e.g. lineage)
 *   - group_interest: optional comma-separated subset of groups to analyse
 * Outputs: _summary.tsv + _distribution.tsv
 */

// Parameters
params.distribution_group_column = "lineage"
params.distribution_group_interest = ""
params.distribution_output_dir = "results/distribution"

// Process ---------------------------------------------------------------
process ALLELIC_DISTRIBUTION {
    container = "docker.io/library/python:3.10-slim"
    cpus = 4
    memory = "8.GB"
    time = "120min"

    input:
        path allele_matrix
        path metadata

    output:
        path "${params.distribution_output_dir}/${task.ext.prefix}_${params.distribution_group_column}_summary.tsv"      | into: summary
        path "${params.distribution_output_dir}/${task.ext.prefix}_${params.distribution_group_column}_distribution.tsv" | into: distribution

    script:
        def out_prefix = params.distribution_output_dir + "/" + task.ext.prefix
        def group_col = params.distribution_group_column
        def args = [
            "--alleles", allele_matrix.toString(),
            "--metadata", metadata.toString(),
            "--group-column", group_col,
            "--output", out_prefix,
        ]
        if (params.distribution_group_interest != null && !params.distribution_group_interest.toString().trim().isEmpty()) {
            args += ["--group-interest", params.distribution_group_interest.toString()]
        }

        """
        python ${projectDir}/modules/local/allelic-distribution/bin/allelic_distribution.py \\\\
            ${args.collect { "'$it'" }.join(" ")}
        """
}
