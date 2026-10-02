#!/usr/bin/env bash
set -euo pipefail

mkdir -p /projects/rnaseq_project/{annotation,reads,metadata,variants,expression,results,scripts}

cd /projects/rnaseq_project

cat > metadata/samples.tsv <<'EOF'
sample_id	patient	condition	batch
Tumor_01	P001	tumor	B1
tumor_02	P002	tumor	B1
Normal_01	P003	normal	B2
normal_02	P004	normal	B2
Tumor_03	P005	tumor	B3
EOF

cp metadata/samples.tsv metadata/old_samples.tsv

cat > metadata/.analysis_notes.tsv <<'EOF'
sample_id	qc_status	mapped_reads	notes
Tumor_01	QC_PASS	45000000	good_quality
tumor_02	QC_FAIL	12000000	low_reads
Normal_01	QC_PASS	51000000	good_quality
normal_02	QC_PASS	48000000	good_quality
Tumor_03	QC_PASS	55000000	good_quality
Tumor_01	QC_PASS	45000000	duplicate_entry
EOF

cat > variants/variants.tsv <<'EOF'
variant_id	gene	chromosome	consequence	clinical_significance	sample
var001	TP53	chr17	missense	Pathogenic	Tumor_01
var002	BRCA1	chr17	frameshift	Pathogenic	Tumor_01
var003	EGFR	chr7	missense	Likely_pathogenic	Tumor_01
var004	PTEN	chr10	synonymous	Benign	normal_02
var005	TP53	chr17	nonsense	Pathogenic	tumor_02
var006	EGFR	chr7	missense	Uncertain_significance	tumor_02
var007	MYC	chr8	missense	Likely_pathogenic	Tumor_03
var008	BRCA1	chr17	missense	Pathogenic	Tumor_03
var009	PTEN	chr10	frameshift	Pathogenic	Tumor_03
var010	TP53	chr17	missense	Pathogenic	Tumor_01
var010	TP53	chr17	missense	Pathogenic	Tumor_01
EOF

cat > expression/expression.tsv <<'EOF'
gene_id	gene_name	tumor_1	tumor_2	normal_1	normal_2
ENSG001	TP53	120	110	18	22
ENSG002	BRCA1	75	82	60	58
ENSG003	EGFR	150	165	40	35
ENSG004	PTEN	45	55	42	47
ENSG005	MYC	210	190	30	28
ENSG006	GAPDH	95	100	98	102
EOF

cat > annotation/gencode_subset.gtf <<'EOF'
# Synthetic teaching subset derived from a real GTF structure
# Preliminary annotation received from collaborator
# TODO: verify duplicate records before downstream analysis
chr17	HAVANA	gene	7661779	7687550	.	+	.	gene_id "ENSG00000141510"; gene_name "TP53"; gene_type "protein_coding";
chr17	HAVANA	transcript	7661779	7687550	.	+	.	gene_id "ENSG00000141510"; gene_name "TP53"; gene_type "protein_coding";
chr17	HAVANA	gene	4119772	4127750	.	+	.	gene_id "ENSG00000012048"; gene_name "BRCA1"; gene_type "protein_coding";
chr17	HAVANA	gene	4119772	4127750	.	+	.	gene_id "ENSG00000012048"; gene_name "BRCA1"; gene_type "protein_coding";
chr7	HAVANA	gene	55086714	55275031	.	-	.	gene_id "ENSG00000146648"; gene_name "EGFR"; gene_type "protein_coding";
chr10	HAVANA	gene	87863990	87971945	.	+	.	gene_id "ENSG00000171862"; gene_name "PTEN"; gene_type "protein_coding";
chr8	HAVANA	gene	127735434	127742951	.	+	.	gene_id "ENSG00000136997"; gene_name "MYC"; gene_type "protein_coding";
chrX	HAVANA	gene	31093812	33357813	.	+	.	gene_id "ENSG00000198947"; gene_name "DMD"; gene_type "protein_coding";
chrM	HAVANA	gene	3307	4262	.	+	.	gene_id "ENSG00000198888"; gene_name "MT-ND1"; gene_type "protein_coding";
chr17	HAVANA	gene	7663000	7665000	.	+	.	gene_id "ENSG000002XXXXXX"; gene_name "TP53P1"; gene_type "processed_pseudogene";
EOF

cp annotation/gencode_subset.gtf annotation/gencode_subset.gtf.backup

cat > annotation/notes.txt <<'EOF'
Annotation received from collaborator.

Use the GTF for the preliminary RNA-seq analysis.

Some records may require inspection before downstream analysis.
EOF

touch \
    reads/Tumor_01_R1.fastq.gz \
    reads/Tumor_01_R2.fastq.gz \
    reads/tumor_02_R1.fastq.gz \
    reads/tumor_02_R2.fastq.gz \
    reads/Normal_01_R1.fastq.gz \
    reads/Normal_01_R2.fastq.gz \
    reads/normal_02_R1.fastq.gz \
    reads/normal_02_R2.fastq.gz \
    reads/Tumor_03_R1.fastq.gz \
    reads/Tumor_03_R2.fastq.gz

cat > reads/manifest.txt <<'EOF'
Tumor_01_R1.fastq.gz
Tumor_01_R2.fastq.gz
tumor_02_R1.fastq.gz
tumor_02_R2.fastq.gz
Normal_01_R1.fastq.gz
Normal_01_R2.fastq.gz
normal_02_R1.fastq.gz
normal_02_R2.fastq.gz
Tumor_03_R1.fastq.gz
Tumor_03_R2.fastq.gz
Tumor_03_R2.fastq.gz
EOF

find /projects/rnaseq_project