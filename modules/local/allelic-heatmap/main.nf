#!/usr/bin/env nextflow
/**
 * cgMLST allelic-heatmap module.
 *
 * Wraps the Lohdia et al. (2025) `allelic_heatmap.py` script from
 * https://github.com/insapathogenomics/allelic_diversity (v1.0.0).
 * Produces an interactive Plotly heatmap of cgMLST allele distribution
 * across a single-linkage species tree, plus summary/dominance tables.
 *
 * Inputs:
 *   - allele_matrix: cgMLST allele matrix TSV (samples x loci; '0' = missing)
 *   - metadata: sample metadata TSV (samples x columns; one column = categories)
 *   - tree: single-linkage hierarchical clustering dendrogram (Newick)
 * Outputs: HTML heatmap + _allele_summary.tsv + _allele_summary_counts.tsv
 *          + _allele_dominance.tsv + _allelic_detailed_matrix.tsv + _colors.tsv
 */

params.heatmap_output_dir = "results/heatmap"
params.heatmap_output_prefix = "heatmap"
params.heatmap_group_column = "lineage"
params.heatmap_mode = "frequency"
params.heatmap_ncat = 3
params.heatmap_ncat_dominant = 3

process ALLELIC_HEATMAP {
    container = "docker.io/library/python:3.10-slim"
    cpus = 4
    memory = "16.GB"
    time = "120min"

    input:
        path allele_matrix
        path metadata
        path tree

    output:
        path "${params.heatmap_output_dir}/${params.heatmap_output_prefix}.html"                | into: heatmap_html
        path "${params.heatmap_output_dir}/${params.heatmap_output_prefix}_allele_summary.tsv"                | into: allele_summary
        path "${params.heatmap_output_dir}/${params.heatmap_output_prefix}_allele_summary_counts.tsv"       | into: allele_summary_counts
        path "${params.heatmap_output_dir}/${params.heatmap_output_prefix}_allele_dominance.tsv"              | into: allele_dominance
        path "${params.heatmap_output_dir}/${params.heatmap_output_prefix}_allelic_detailed_matrix.tsv"     | into: allelic_detailed_matrix
        path "${params.heatmap_output_dir}/${params.heatmap_output_prefix}_colors.tsv"                        | into: auto_colors

    script:
        def out_prefix = "${params.heatmap_output_dir}/${params.heatmap_output_prefix}"
        def script_path = "${projectDir}/modules/local/allelic-heatmap/bin/allelic_heatmap.py"
        def args = [
            "--allelic_matrix", allele_matrix.toString(),
            "--metadata", metadata.toString(),
            "--tree", tree.toString(),
            "--header", params.heatmap_group_column,
            "--output_prefix", out_prefix,
            "--mode", params.heatmap_mode,
        ]
        if (params.heatmap_ncat != null) args += ["--ncat", params.heatmap_ncat.toString()]
        if (params.heatmap_ncat_dominant != null) args += ["--ncat_dominant", params.heatmap_ncat_dominant.toString()]

        """
        python "$script_path" ${args.collect { "'$it'" }.join(" ")}
        """
}
