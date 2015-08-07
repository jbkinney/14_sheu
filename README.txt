This repository contains the processed data and analysis scripts for the paper,

Sheu Y-J, Kinney JB, Stillman B. (2015) Concerted activities of Mcm4, Sld3 and Dbf4 in control of origin activation and DNA replication fork progression.
bioRxiv doi: http://dx.doi.org/10.1101/021832.

These scripts start with 'heights_*.*.*.txt' files, available in the 'data' directory, and produce the plots published in our paper. They also produce two files,

results/result_peak_heights.txt
results/result_peak_widths.txt

which are provided with this release. 

0. First we need to collate information from all Illumina runs ('data/heights_*.*.*.txt') into one file, 'data/heights_all.txt'. To do this, execute the following command at the system commandline (indicated by $):

	$ ./script_0_concatenate_height_files.py

1. To compute smoothed replication profiles for all samples, open Matlab and, at the MATLAB commandline (indicated by >>), execute

	>> run script_1_compute_abundances.m

2. To make plots, open Matlab and, at the MATLAB commandline (indicated by >>), execute

	>> run script_2_run_analysis.m

4. To remove all files created by these scripts, run

	$ ./script_3_cleanup.sh
