---
layout: page
title: GTF format
navigation: 7
---

# General Transfer Format


The file we have just downloaded provides information on the genome annotation.

The genomic annotation is stored in **G**eneral **T**ransfer **F**ormat (**GTF**) format (which is an extension of the older **[GFF format](https://genome.ucsc.edu/FAQ/FAQformat.html#format3)**): a tabular format that has a header (rows starting with **"#"**, following by one line per genome feature, each one containing 9 columns of data:<br>

| Column number | Column name | Details |
| ----: | :---- | :---- |
| 1 | seqname | name of the chromosome or scaffold; chromosome names can be given with or without the 'chr' prefix. |
| 2 | source | name of the program that generated this feature, or the data source (database or project name) |
| 3 | feature | feature type name, e.g. Gene, Variation, Similarity |
| 4 | start | Start position of the feature, with sequence numbering starting at 1. |
| 5 | end | End position of the feature, with sequence numbering starting at 1. |
| 6 | score | A floating point value. |
| 7 | strand | defined as + (forward) or - (reverse). |
| 8 | frame | One of '0', '1' or '2'. '0' indicates that the first base of the feature is the first base of a codon, '1' that the second base is the first base of a codon, and so on.. |
| 9 | attribute | A semicolon-separated list of tag-value pairs, providing additional information about each feature. |


Check the first rows of the annotation file:

```{bash}
zcat annotation.gtf.gz | head
##description: evidence-based annotation of the human genome (GRCh38), version 32 (Ensembl 98)
##provider: GENCODE
##contact: gencode-help@ebi.ac.uk
##format: gtf
##date: 2019-09-05
chr21	HAVANA	gene	5011799	5017145	.	+	.	gene_id "ENSG00000279493.1"; gene_type "protein_coding"; gene_name "FP565260.4"; level 2; havana_gene "OTTHUMG00000189354.1";
chr21	HAVANA	transcript	5011799	5017145	.	+	.	gene_id "ENSG00000279493.1"; transcript_id "ENST00000624081.1"; gene_type "protein_coding"; gene_name "FP565260.4"; transcript_type "protein_coding"; transcript_name "FP565260.4-201"; level 2; protein_id "ENSP00000485664.1"; transcript_support_level "5"; tag "mRNA_start_NF"; tag "cds_start_NF"; tag "basic"; tag "appris_principal_1"; havana_gene "OTTHUMG00000189354.1"; havana_transcript "OTTHUMT00000479422.1";
chr21	HAVANA	exon	5011799	5011874	.	+	.	gene_id "ENSG00000279493.1"; transcript_id "ENST00000624081.1"; gene_type "protein_coding"; gene_name "FP565260.4"; transcript_type "protein_coding"; transcript_name "FP565260.4-201"; exon_number 1; exon_id "ENSE00003760288.1"; level 2; protein_id "ENSP00000485664.1"; transcript_support_level "5"; tag "mRNA_start_NF"; tag "cds_start_NF"; tag "basic"; tag "appris_principal_1"; havana_gene "OTTHUMG00000189354.1"; havana_transcript "OTTHUMT00000479422.1";
chr21	HAVANA	CDS	5011799	5011874	.	+	0	gene_id "ENSG00000279493.1"; transcript_id "ENST00000624081.1"; gene_type "protein_coding"; gene_name "FP565260.4"; transcript_type "protein_coding"; transcript_name "FP565260.4-201"; exon_number 1; exon_id "ENSE00003760288.1"; level 2; protein_id "ENSP00000485664.1"; transcript_support_level "5"; tag "mRNA_start_NF"; tag "cds_start_NF"; tag "basic"; tag "appris_principal_1"; havana_gene "OTTHUMG00000189354.1"; havana_transcript "OTTHUMT00000479422.1";
chr21	HAVANA	exon	5012548	5012687	.	+	.	gene_id "ENSG00000279493.1"; transcript_id "ENST00000624081.1"; gene_type "protein_coding"; gene_name "FP565260.4"; transcript_type "protein_coding"; transcript_name "FP565260.4-201"; exon_number 2; exon_id "ENSE00003758404.1"; level 2; protein_id "ENSP00000485664.1"; transcript_support_level "5"; tag "mRNA_start_NF"; tag "cds_star
```

Let's check how many genes are in the annotation file:

```{bash}
zcat annotation.gtf.gz | grep -v "#" | awk '$3=="gene"' | wc -l 
872
```

And get a final counts of every feature:

```{bash}
zcat annotation.gtf.gz | grep -v "#" | cut -f3 | sort | uniq -c 

   7709 CDS
  16659 exon
    872 gene
    857 start_codon
    813 stop_codon
   2925 transcript
   2896 UTR
```

How many **protein coding genes** are there?

```{bash}
zcat annotation.gtf.gz | grep -v "#" | awk '$3=="gene"' | grep "protein_coding" | wc -l 
232
```

Retrieve all unique **gene IDs** (let's look up for the options of commands cut and sort using man):

```{bash}
zcat annotation.gtf.gz | grep -v "#" | cut -d"\"" -f2 | sort -u > annotation_geneIDs.txt
```

Here, we use the fact that gene ID appears after the first and before the second occurance of doublequote (") !
That is why we used the command **cut -d"\""** where backslash (\) is used as an escape character for special characters (" in this case).

<br/>

**EXERCISE**
<br>
 * How many lncRNA genes are in the file annotation.gtf.gz? 
 
<br>
TIP: Command **cut** can be used with different one-character separators and applied to different columns many times in a sequence via pipe.
<br>
