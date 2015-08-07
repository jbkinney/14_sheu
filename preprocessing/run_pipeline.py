#!/opt/hpc/pkg/python-2.7/bin/python
import os, sys, time, commands
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from ruffus import *

original_genome_file = 'data/genome.fasta'
genome_dir = 'genome/'
genome_file = genome_dir+'genome.fasta'
barcodes_file = 'data/barcodes.txt' 
reads_file = 'data/sample.fastq' 
reads_dir = 'reads/'
reads_file_qual = reads_dir+'reads_qual.fastq'
scripts_dir = 'scripts/'
mappings_dir = 'mappings/'
pileups_dir = 'pileups/'
bwa_index_files = [genome_dir+'/genome.fasta.'+ext for ext in ['amb','ann','bwt','pac','rbwt','rpac','rsa','sa']]
barcode_len = 5
min_quality = 10
read_length = 31 #36 bp read - 5 bp barcode, but if you change this the pipeline will break.
chromosome_starts_file = genome_dir+'chromosome_starts.txt'

sample_names = [line.split()[0] for line in open(barcodes_file)];
num_samples = len(sample_names);
reads_files_split = [reads_dir+'tmp1_'+name+'.fastq' for name in sample_names];
reads_files = [reads_dir+name+'.fastq' for name in sample_names];

###################################################################################

# Useful way to give feedback
def give_feedback(feedback):
    func_name =sys._getframe(1).f_code.co_name
    print '\nIn '+func_name+': '+feedback,
    sys.stdout.flush()

def clean_and_copy_scer_fasta(original_scer_fasta, scer_fasta):
    # Read in S.cer genome.
    # Write out a version of this genome with simplified contig names and without mitochondiral DNA
    new_seq_records = []
    for seq_record in SeqIO.parse(original_scer_fasta, 'fasta'):
        gi_number = seq_record.id
        chromosome_num = int(gi_number.split('_')[1].strip('|')) - 1132
        if chromosome_num not in range(1,17):
            continue
        
        # Create new seq record with chromosome number as id
        new_seq_record = seq_record
        new_seq_record.id = str(chromosome_num)
        new_seq_records.append(new_seq_record)
    
    # Write all Scer chromosomes to output file
    SeqIO.write(new_seq_records, scer_fasta, 'fasta')
    
# Returns a list of contig starting positions
def get_contig_starts(genome_file_name):
    contig_start_dict = {}
    pos = 0
    for seq_record in SeqIO.parse(genome_file_name, 'fasta'):
        contig_start_dict[seq_record.id] = pos+1
        pos += len(seq_record)
    genome_len = pos
    return contig_start_dict, genome_len
    
# Saves contig starting positions and genome lenght to a gext file
def save_contig_starts(contig_starts_dict, genome_len, out_file_name):
    f = open(out_file_name,'w')
    f.write('TOTAL\t'+str(genome_len)+'\n')
    poss = contig_starts_dict.values();
    poss.sort()
    for pos in poss:
        contig = [k for k,v in contig_starts_dict.items() if v==pos][0]
        f.write('\t'.join([contig, str(pos)])+'\n')
    f.close()

# Submits a list of scripts to be run as separate jobs
# Waits for all jobs to complete before continuing
def submit_and_complete_jobs(scripts):
    
    # Clear scripts dir
    os.system('rm %s*' %scripts_dir)

    # Write and execute scripts
    for n, script in enumerate(scripts):
        script_name = scripts_dir + 'script_num_%d.sh'%n 
        f = open(script_name, 'w')
        f.write(script)
        f.close()
        os.system('chmod +x '+script_name)
        os.system('qsub -cwd -e %s -o %s %s > .junk' % (script_name+'.e', script_name+'.o', script_name))
        
    # Monitor jobs 
    give_feedback('Waiting for jobs to complete...')
    jobs_remaining = len(scripts)
    wait_time = 60
    start_time = time.time()
    while jobs_remaining > 0:
        give_feedback(str(jobs_remaining)+' jobs remaining; waiting '+str(wait_time)+' seconds...')
        time.sleep(wait_time)
        jobs_remaining = int(commands.getoutput('qstat | grep script_num | wc -l'))

    # Announce job completion
    finish_time = time.time()
    give_feedback('All jobs finished after %.1f seconds'%(finish_time - start_time))
    give_feedback('Done.\n')

###################################################################################

# Filter reads by quality
@files(reads_file, reads_file_qual)
def stage_one(ins, outs):
    give_feedback('Filtering reads by quality...\n')   
    script = '''
    source ~/.bash_profile  
    fastq_quality_filter -Q33 -q %d -p %d -i %s -o %s 
    ''' % (min_quality, 90, reads_file, reads_file_qual) 
    submit_and_complete_jobs([script])

# Organize reads by barcode
@follows(stage_one)
@files(reads_file_qual, reads_files_split)
def stage_two(ins, outs):
    give_feedback('Splitting reads by batch...\n')
    script = '''
    source ~/.bash_profile
    cat %s | fastx_barcode_splitter.pl --bcfile %s --prefix %s --suffix %s --mismatches 0 --bol
    ''' % (reads_file_qual, barcodes_file, reads_dir+'tmp1_', '.fastq')
    script_name = scripts_dir+'filter_reads.sh' 
    submit_and_complete_jobs([script])

# Trim reads
@follows(stage_two)
@files(reads_files_split, reads_files)
def stage_three(ins,outs):
    give_feedback('Trimming barcodes from reads...\n')
    scripts = []
    for i in range(num_samples):
        infile = reads_files_split[i]
        outfile = reads_files[i]
        print infile+'->'+outfile
        script = '''
        source ~/.bash_profile
        fastx_trimmer -Q33 -f %d -i %s -o %s 
        ''' % (barcode_len+1, infile, outfile)
        scripts.append(script)
    submit_and_complete_jobs(scripts)

# Copy genome file locally, getting rid of mitochondrial DNA, and get chromosome start positions
@follows(stage_three)
@files(original_genome_file, [genome_file, chromosome_starts_file])
def stage_three_2(ins,outs):
    give_feedback('Copying genome locally and getting chromosome start positions...')
    clean_and_copy_scer_fasta(original_genome_file, genome_file)
    contig_starts, genome_len = get_contig_starts(genome_file)
    save_contig_starts(contig_starts, genome_len, chromosome_starts_file)
    give_feedback('Done.\n')

# Create bwa index for genome
@follows(stage_three_2)
@files(genome_file, bwa_index_files)
def stage_four(ins,outs):
    give_feedback('Creating bwa index...')
    script = '''
    source ~/.bash_profile
    bwa index %s''' % genome_file
    submit_and_complete_jobs([script])

# Map sample reads to genome
sam_files = [mappings_dir+name+'.sam' for name in sample_names];
@follows(stage_four)
@files([bwa_index_files, reads_files],sam_files)
def stage_five(ins,outs):
    give_feedback('Mapping reads to the genome...\n')
    scripts = []
    for n, name in enumerate(sample_names):
        map_name = mappings_dir+name
        script = '''
        source ~/.bash_profile
        bwa aln %s %s > %s.sai
        bwa samse %s %s.sai %s > %s
        ''' \
        % (genome_file, reads_files[n], map_name, \
           genome_file, map_name, reads_files[n], sam_files[n])
        scripts.append(script)
    submit_and_complete_jobs(scripts)


# Create pileup
pileup_files = [pileups_dir+name+'.pileup' for name in sample_names];
@follows(stage_five)
@files(sam_files, pileup_files)
def stage_six(ins,outs):
    give_feedback('Creating pileups...\n')
    scripts = []
    for n, name in enumerate(sample_names):
        pileup_name = mappings_dir+name
        script = '''
        source ~/.bash_profile
        samtools view -bS %s > %s.bam
        samtools sort %s.bam %s.sorted
        samtools index %s.sorted.bam
        samtools pileup -c -f %s %s.sorted.bam > %s
        ''' \
        % (sam_files[n], pileup_name, \
           pileup_name, pileup_name, \
           pileup_name, \
           genome_file, pileup_name, pileup_files[n])
        scripts.append(script)
    submit_and_complete_jobs(scripts)

# Collate pileup heights into a single file
height_file = pileups_dir+'heights.txt'
@follows(stage_six)
@files(pileup_files, height_file)
def stage_seven(ins,outs):

    # Get chromosome lengths
    give_feedback('Getting chromosome lengths...')
    chromosome_lengths = [len(seq_record) for seq_record in SeqIO.parse(genome_file,'fasta')]
    num_chromosomes = len(chromosome_lengths)

    # Pre-form dictionary
    give_feedback('Reserving memory for height file...')
    entries = []
    x = [0 for f in pileup_files]
    for n in range(num_chromosomes):
        entries.extend([((n+1, p), x[:]) for p in range(1,chromosome_lengths[n],read_length)])

    # Fill dictionary with values
    read_counts_dict = dict(entries)
    for i,file in enumerate(pileup_files):
        give_feedback('Processing '+file+'...')
        for line in open(file):
            atoms = line.split()
            chromosome = int(atoms[0])
            position = int(atoms[1])
            num_reads = int(atoms[7])
            if position%31 == 1:
                read_counts_dict[(chromosome, position)][i] = num_reads
            
    # Write pileup heights to file
    give_feedback('Writing height file...')
    outf = open(height_file,'w')
    line = 'CHR\tPOS\t'+'\t'.join([f.split('.')[0].split('/')[-1] for f in pileup_files])+'\n'
    outf.write(line)
    sorted_keys = sorted(read_counts_dict.keys())
    for k in sorted_keys:
        v = read_counts_dict[k]
        line = '\t'.join([str(x) for x in k])
        line += '\t'+'\t'.join([str(x) for x in v])+'\n'
        outf.write(line)
    outf.close()

    give_feedback('Done.\n')
        


### Run pipeline
print '##################################################'
print 'Begin read mapping pipeline'
pipeline_start_time = time.time()
pipeline_run([stage_seven])
interval = time.time() - pipeline_start_time
print '\nPipeline Done! Runtime: %.1f min' % (interval/60.0)
print '##################################################'


    
    
