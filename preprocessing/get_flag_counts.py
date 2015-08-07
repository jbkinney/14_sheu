#!/usr/bin/python

import glob
import os

bam_files = glob.glob('mappings/*.bam')
bam_files = [f for f in bam_files if not 'sorted' in f]

command = "/data/kinney/software/bin/samtools view %s | awk '{print $2}' | sort | uniq -c > %s "
for bam_file in bam_files:
    print 'Processing %s...'%bam_file
    counts_file = bam_file.split('.')[0]+'.counts'
    os.system(command%(bam_file, counts_file))
    os.system('cat %s'%counts_file)
print 'Done!'
