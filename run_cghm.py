# Run the cgMLST heatmap/distribution pipeline
#
# Usage:
#   python run_cghm.py --allele-matrix data/Ct_alleles_missing_code_0.tsv \
#     --metadata data/Ct_metadata.tsv --tree data/Ct_HC_single_HC.nwk \
#     --output-prefix heatmap --group-column lineage --mode frequency

import argparse
import os
import subprocess
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
HEATMAP_SCRIPT = os.path.join(SCRIPT_DIR, "modules", "local", "allelic-heatmap", "bin", "allelic_heatmap.py")
DISTRIBUTION_SCRIPT = os.path.join(SCRIPT_DIR, "modules", "local", "allelic-distribution", "bin", "allelic_distribution.py")


def run_heatmap(args):
    out_prefix = os.path.join(args.output_dir, args.output_prefix)
    cmd = [
        sys.executable, HEATMAP_SCRIPT,
        "--allelic_matrix", args.allele_matrix,
        "--metadata", args.metadata,
        "--tree", args.tree,
        "--header", args.group_column,
        "--output_prefix", out_prefix,
        "--mode", args.mode,
    ]
    if args.ncat is not None:
        cmd += ["--ncat", str(args.ncat)]
    if args.ncat_dominant is not None:
        cmd += ["--ncat_dominant", str(args.ncat_dominant)]
    print("[INFO]", " ".join(cmd))
    subprocess.run(cmd, check=True)


def run_distribution(args):
    out_prefix = os.path.join(args.output_dir, args.output_prefix)
    cmd = [
        sys.executable, DISTRIBUTION_SCRIPT,
        "--allele", args.allele_matrix,
        "--metadata", args.metadata,
        "--group-column", args.group_column,
        "--output", out_prefix,
    ]
    if args.group_interest:
        cmd += ["--group-interest", args.group_interest]
    print("[INFO]", " ".join(cmd))
    subprocess.run(cmd, check=True)


def main():
    parser = argparse.ArgumentParser(description="cgMLST heatmap/distribution pipeline (Lohdia et al. 2025)")
    parser.add_argument("--allele-matrix", required=True, help="cgMLST allele matrix TSV")
    parser.add_argument("--metadata", required=True, help="sample metadata TSV")
    parser.add_argument("--tree", required=True, help="single-linkage dendrogram (Newick)")
    parser.add_argument("--output-dir", default="results", help="output directory")
    parser.add_argument("--output-prefix", default="heatmap", help="output prefix")
    parser.add_argument("--group-column", default="lineage", help="metadata column for grouping")
    parser.add_argument("--mode", default="frequency", choices=["frequency", "count"])
    parser.add_argument("--ncat", type=int, default=3, help="nearly-conserved threshold (categories)")
    parser.add_argument("--ncat-dominant", type=int, default=3, help="nearly-conserved threshold (dominant)")
    parser.add_argument("--group-interest", default="", help="optional comma-separated groups to subset")
    parser.add_argument("--which", choices=["heatmap", "distribution", "both"], default="heatmap")
    args = parser.parse_args()

    os.makedirs(args.output_dir, exist_ok=True)
    if args.which in ("heatmap", "both"):
        run_heatmap(args)
    if args.which in ("distribution", "both"):
        run_distribution(args)


if __name__ == "__main__":
    main()
