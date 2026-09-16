/**
 * Main cgMLST heatmap pipeline.
 *
 * Runs the Lohdia et al. (2025) cgMLST allelic-heatmap and allelic-distribution
 * analysis.  Container/resource defaults come from config.nf.
 */

params {
    input_allele_matrix = "data/Ct_alleles_missing_code_0.tsv"
    input_metadata = "data/Ct_metadata.tsv"
    input_tree = "data/Ct_HC_single_HC.nwk"
    output_prefix = "heatmap"
    group_column = "lineage"
    mode = "frequency"
    ncat = 3
    ncat_dominant = 3
}

process ALLELIC_HEATMAP {
    input:
        path allele_matrix
        path metadata
        path tree

    output:
        path "results/heatmap/${params.output_prefix}.html"
        path "results/heatmap/${params.output_prefix}_allele_summary.tsv"
        path "results/heatmap/${params.output_prefix}_allele_summary_counts.tsv"
        path "results/heatmap/${params.output_prefix}_allele_dominance.tsv"
        path "results/heatmap/${params.output_prefix}_allelic_detailed_matrix.tsv"
        path "results/heatmap/${params.output_prefix}_colors.tsv"

    script:
        def out_prefix = "results/heatmap/${params.output_prefix}"
        def script_path = "${projectDir}/modules/local/allelic-heatmap/bin/allelic_heatmap.py"
        def args = [
            "--allelic_matrix", allele_matrix.toString(),
            "--metadata", metadata.toString(),
            "--tree", tree.toString(),
            "--header", params.group_column,
            "--output_prefix", out_prefix,
            "--mode", params.mode,
        ]
        if (params.ncat != null) args += ["--ncat", params.ncat.toString()]
        if (params.ncat_dominant != null) args += ["--ncat_dominant", params.ncat_dominant.toString()]

        """
        python "$script_path" ${args.collect { "'$it'" }.join(" ")}
        """
}

process ALLELIC_DISTRIBUTION {
    input:
        path allele_matrix
        path metadata

    output:
        path "results/distribution/${params.output_prefix}_${params.group_column}_summary.tsv"
        path "results/distribution/${params.output_prefix}_${params.group_column}_distribution.tsv"

    script:
        def out_prefix = "results/distribution/${params.output_prefix}"
        def script_path = "${projectDir}/modules/local/allelic-distribution/bin/allelic_distribution.py"
        def args = [
            "--allele", allele_matrix.toString(),
            "--metadata", metadata.toString(),
            "--group-column", params.group_column,
            "--output", out_prefix,
        ]

        """
        python "$script_path" ${args.collect { "'$it'" }.join(" ")}
        """
}

workflow {
    ALLELIC_HEATMAP(
        file(params.input_allele_matrix),
        file(params.input_metadata),
        file(params.input_tree),
    )

    ALLELIC_DISTRIBUTION(
        file(params.input_allele_matrix),
        file(params.input_metadata),
    )
}
