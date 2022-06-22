#!/usr/bin/env nextflow


/* --------------------------
  Set up variables
 ----------------------------*/

 // input vcfs

 vcf_ch = Channel
			.fromPath(params.vcf_list)
			.ifEmpty { exit 1, "Cannot find input file : ${params.input_vcf}" }
			.splitCsv(skip:1)
			.map { row -> tuple(row[0], file(row[1]), file(row[2]))}
			.take( params.number_of_files_to_process )
			




/*---------------------
  Start pipeline
 ----------------------*/

 /*---------------------
  Check disk size
 ----------------------*/


 process check_disk_size {

	echo true

	input:
	tuple val(sampleID), file(vcf), file(index) from vcf_ch

	script:

	"""
	bcftools query -l ${vcf} > ${vcf}_header.txt
	rm ${vcf}_header.txt
	hostname
	df -h
	"""

 }
 