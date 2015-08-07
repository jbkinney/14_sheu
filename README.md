# Analysis pipeline for Sheu et al. (2015)

## Reference

Sheu Y-J, Kinney JB, Stillman B. (2015) Concerted activities of Mcm4, Sld3 and Dbf4 in control of origin activation and DNA replication fork progression.

bioRxiv doi: http://dx.doi.org/10.1101/021832.

## Data

#### Raw data

Raw sequence reads are available on the NCBI Sequences Reach Archive, accesion number [SRA279689](http://www.ncbi.nlm.nih.gov/sra/?term=SRA279689). Data for seven experiments are provided: 15.02.25_sheu, 14.11.25_sheu, 14.10.15_sheu, 14.08.20_sheu, 14.07.28_sheu, 14.04.14_sheu, 13.05.28_sheu. The file `data/sample_info.txt` describes which samples are contained in each dataset. Molecular barcodes are listed in `data/barcodes.txt`.

#### Processed data

Non-smoothed replication profiles are stored in the files `data/heights_XX.XX.XX.txt`. Replication peak height and width measurements are reported in `results/result_peak_heights.txt` and `results/result_peak_widths.txt`.

## Pipeline

The data analysis pipeline consists of two parts: 

1. A preprocessing pipeline that maps Illumina reads to the yeast genome and computes non-smoohed replication profiles.
 
2. An analysis pipeline that computes smoothed replicaiton profiles, returns measurements of replication peak widths and heights, and generates the plots shown in the paper.

#### Preprocessing

The directory `preprocessing/` contains the code used in the data preprocessing pipeline. To run this pipeline, execute

```
$ ./preprocessing/run_pipeline.py
```

Doing this maps the Illumina reads in the mock data set `preprocessing/data/sample.fastq` and stores the resulting non-smoothed replication profiles in `preprocessing/pileups/heights.txt`. 


#### Analysis

The non-smoothed replication profiles generated from all seven experiments are stored in the `data/heights_XX.XX.XX.txt` files. To concatenate these files into the single file `data/heights_all.txt` used in subsequent analysis, execute the Python script

```
$ ./script_0_concatenate_height_files.py
```

To compute smoothed replication profiles using the data in `data/heights_all.txt`, exectute the following at the Matlab commandline (indicated by `>>`):

```
>> run script_1_compute_abundances.m
```
	
This script also creates the files

```
results/result_peak_heights.txt
results/result_peak_widths.txt
```

which contain the measurements of peak heights and widths height for all of the samples. To then make plots, execute the following at the Matlab commandline:

```
>> run script_2_run_analysis.m
```

Currently, line 5 of `script_2_run_analysis.m` sets `run_test_analysis = true`. This tells the script to only produce one of each type of plot (for testing purposes). To instead have `script_2_run_analysis.m` generate all of the plots shown in the paper, change this line to `run_test_analysis = false`. Note: the specific plots to generate are specified in the files `specifications/set_plot_specifications_*.m`. 

Finally, to remove all files created by these analysis scripts, run

```
$ ./script_3_cleanup.sh
```
