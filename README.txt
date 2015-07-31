Last edited by JB Kinney on 15.07.31

0. First we need to collate information from all Illumina runs ('data/heights_*.*.*.txt') into one file, 'data/heights_all.txt'. To do this, execute the following command at the system commandline (indicated by $):

	$ ./script_0_concatenate_height_files.py

1. To compute smoothed replication profiles for all samples, open Matlab and, at the MATLAB commandline (indicated by >>), execute

	>> run script_1_compute_abundances.m

2. To make plots, open Matlab and, at the MATLAB commandline (indicated by >>), execute

	>> run script_2_run_analysis.m

4. To remove all files created by these scripts, run

	$ ./script_3_cleanup.sh
