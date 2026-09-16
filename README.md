# cgMLST Heatmap (cgHM) — Nextflow module

Wraps the **allelic-heatmap** and **allelic-distribution** Python scripts from
[Lohdia et al. 2025] *Advancing Chlamydia trachomatis genomic surveillance and
research with a novel core-genome MLST (cgMLST) approach*, published in
*Nature Communications* (PMC13524934). The scripts live at
https://github.com/insapathogenomics/allelic_diversity (v1.0.0,
Zenodo: 10.5281/zenodo.17177356).

## What this project does

* `modules/local/allelic-heatmap/` — nf-core module that runs
  `allelic_heatmap.py`: reads a cgMLST allele matrix (TSV), sample metadata
  (TSV), and a single-linkage dendrogram (Newick), and produces an
  interactive Plotly heatmap + summary/dominance/detailed-matrix tables.
* `modules/local/allelic-distribution/` — nf-core module that runs
  `allelic_distribution.py`: computes per-group allele proportions and
  per-locus allele distribution.
* `run_cghm.py` — convenience wrapper to run the scripts directly on a
  command line (no Nextflow needed).
* `data/` — the 1230-sample Lohdia background allele matrix, metadata, the
  HC dendrogram, and the 846-locus schema reference.
* `environment.yml` — conda environment (Python 3.10 + pandas, numpy,
  biopython, plotly, nextflow).

## Inputs

| File | Format | Description |
|------|--------|-------------|
| `Ct_alleles_missing_code_0.tsv` | TSV (samples × loci) | cgMLST allele matrix (`0` = missing/not-called) |
| `Ct_metadata.tsv` | TSV (samples × columns) | sample metadata (lineage, country, etc.) |
| `Ct_HC_single_HC.nwk` | Newick | single-linkage hierarchical clustering dendrogram |

## Outputs

| File | Description |
|------|-------------|
| `*.html` | interactive Plotly heatmap |
| `*_allele_summary.tsv` | per-group exclusive/shared alleles |
| `*_allele_summary_counts.tsv` | counts of loci/alleles per group |
| `*_allele_dominance.tsv` | dominant allele per group with counts/frequencies |
| `*_allelic_detailed_matrix.tsv` | detailed matrix with category annotations |
| `*_colors.tsv` | auto-generated color palette |
| `*_summary.tsv` | per-group allele proportions |
| `*_distribution.tsv` | per-locus allele distribution per group |

## Usage

### Nextflow pipeline

```bash
nextflow run main.nf -c config.nf
```

`config.nf` points at the test data by default.  Set `params` to point at the
full data:

```nextflow
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
```

### Convenience wrapper

```bash
python run_cghm.py \
    --allele-matrix data/Ct_alleles_missing_code_0.tsv \
    --metadata data/Ct_metadata.tsv \
    --tree data/Ct_HC_single_HC.nwk \
    --output-dir results --output-prefix heatmap \
    --group-column lineage --mode frequency \
    --ncat 3 --ncat-dominant 3
```

### GitHub Actions

`cghm/.github/workflows/test-module.yml` runs a CI job on every push/PR to
`main`: installs deps, runs the Python syntax check, validates Nextflow
syntax, and executes the pipeline against the tiny synthetic test data
(4 samples × 5 loci).

## Key script parameters (from `allelic_heatmap.py -h`)

| Flag | Description |
|------|-------------|
| `-a ALLELIC_MATRIX` | cg/wgMLST allele matrix TSV |
| `-m METADATA` | metadata TSV |
| `-t TREE` | Newick dendrogram |
| `-hcol HEADER` | metadata column for categories (e.g. lineage) |
| `-o OUTPUT_PREFIX` | output prefix |
| `-mode {frequency,count}` | dominant category mode |
| `-ncat N` | nearly-conserved: color gray if allele in ≥N categories |
| `-ncat_dominant N` | nearly-conserved: color gray if allele dominant in ≥N categories |

## References

* Lohdia/Zohra Lodhia et al. 2025. *Advancing Chlamydia trachomatis genomic surveillance and research with a novel core-genome MLST (cgMLST) approach.* Nature Communications 17:9228.
* Script repo: https://github.com/insapathogenomics/allelic_diversity
* Zenodo (scripts v1.0.0): 10.5281/zenodo.17177356
* Zenodo (cgMLST schema + 1230-genome background): 10.5281/zenodo.19120159
* Zenodo (supplementary data + assemblies): 10.5281/zenodo.16814321
