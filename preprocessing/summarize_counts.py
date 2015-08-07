#!/usr/bin/python

import glob
import os

# Meaning of flags in bam file
# 0:  read mapped in forward dir
# 4:  read not mapped in fwd dir
# 16: read mapped in rev dir
# 20: read not mapped in rev dir (???)

summary_file = open('count_summary.txt','w')

data_set_num = 9 ## Make sure this is right. Have to alter manually for different samples

# Get list of count summary files
count_files = sorted(glob.glob('mappings/*.counts'))

line = 'sample\tnum_mapped\tpct_mapped\n'
print line,
summary_file.write(line)

for f in count_files:
    
    # Get sample name
    sample_name = f.split('/')[-1].split('.')[0]+str(data_set_num)

    # Read in the number of counts for each flag; store as a dict with flag as key
    counts_dict = {}
    lines = open(f).readlines()
    for line in lines:
        atoms = line.strip().split()
        if len(atoms) == 2:
            counts_dict[int(atoms[1])] = int(atoms[0])
    
    # Make sure the counts dict only contains the expected flags
    if not all(k in [0, 4, 16, 20] for k in counts_dict.keys()):
        print 'In sample %s:\n:%s'%(sample_name, ''.join(lines))
    else:
        # Compute total reads, number or reads mapped, and percentage of reads mapped
        total_reads = sum(counts_dict.values())
        reads_mapped = counts_dict[0] + counts_dict[16]
        pct_reads_mapped = (100.0*reads_mapped)/total_reads

        line = '%s\t%.2f M\t\t%.1f%%\n'%(sample_name, reads_mapped/1.0E6, pct_reads_mapped)
        print line,
        summary_file.write(line)
 
