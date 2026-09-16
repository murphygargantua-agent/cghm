process {
    container = "docker.io/library/python:3.10-slim"
    cpus = 4
    memory = "4.GB"
    time = "120min"
}

params {
    input_allele_matrix = "modules/local/allelic-heatmap/tests/data/test_matrix.tsv"
    input_metadata = "modules/local/allelic-heatmap/tests/data/test_metadata.tsv"
    input_tree = "modules/local/allelic-heatmap/tests/data/test_tree.nwk"
    output_prefix = "heatmap_test"
    group_column = "lineage"
    mode = "frequency"
    ncat = 3
    ncat_dominant = 3
}
