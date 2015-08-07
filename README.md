# Analysis pipeline for Sheu et al. (2015)

## Reference

Sheu Y-J, Kinney JB, Stillman B. (2015) Concerted activities of Mcm4, Sld3 and Dbf4 in control of origin activation and DNA replication fork progression.

bioRxiv doi: http://dx.doi.org/10.1101/021832.

## Data

#### Raw data

Raw sequence read data is available at on the NCBI Short Reach Archive, accesion number SRA279689. This contains raw Illumina sequence data for seven experiments: 15.02.25_sheu, 14.11.25_sheu, 14.10.15_sheu, 14.08.20_sheu, 14.07.28_sheu,	14.04.14_sheu,	13.05.28_sheu.

#### Processed data

Non-smoothed replication profiles are stored in the files `data/heights_XX.XX.XX.txt`. Repliation peak width and height measurements are reported in `results/result_peak_heights.txt` and `results/result_peak_widths.txt`.

## Pipeline

The data analysis pipeline consists of two parts: 
1. A preprocessing pipeline that maps reads to the genome and computes non-smoohed replication profiles.
2. An analysis pipeline that takes as input non-smoothed replication profiles and computes smoothed replicaiton profiles, returns measurements of replication peak widths and heights, and generates the plots shown in the paper.

#### Preprocessing

The directory `preprocessing/' contains the code used in the data preprocessing pipeline. To run this pipeline, execute

```
$ ./preprocessing/run_pipeline.py
```

Doing this maps the Illumina reads in the test data set `preprocessing/data/sample.fastq` and stores the resulting non-smoothed replication profiles in `preprocessing/pileups/heights.txt`. 


#### Analysis

The non-smoothed replication profiles from all experiments are stored in the `data/heights_XX.XX.XX.txt` files. To concatenate these files into a single file `data/heights_all.txt', execute the Python script

```
$ ./script_0_concatenate_height_files.py
```

To compute smoothed replication profiles for all samples using the data in `data/heights_all.txt', exectute the following at the matlab commandline:

```
>> run script_1_compute_abundances.m
```
	
This script also creates the files

```
results/result_peak_heights.txt
results/result_peak_widths.txt
```

which contain measurements of peak width and height for all of the samples analyzed. 

To make plots, open Matlab and, at the MATLAB commandline (indicated by >>), execute

	>> run script_2_run_analysis.m

4. To remove all files created by these scripts, run

	$ ./script_3_cleanup.sh
