#!/usr/bin/env python2.7

# TO ADD A NEW DATA SET, INCLUDE FILE NAME IN THIS LIST
heights_dir = 'data/'
heights_files = [
    heights_dir + name for name in '''
        heights_13.05.28.txt
        heights_14.04.14.txt
        heights_14.07.28.txt
        heights_14.08.20.txt
        heights_14.10.15.txt
        heights_14.11.25.txt
        heights_15.02.25.txt
        '''.split()]
heights_all_file = heights_dir + 'heights_all.txt'
info_file = heights_dir + "sample_info.txt"

# Tell user basically what is going on
print('Creating %s...'%heights_all_file)

# Load info file, and make a dictionary that maps date, old_name pairs to new_name
sample_name_dict = {}
f = open(info_file)
split_lines = [l.split(',') for l in f.readlines()]
atom_list = [[a.strip() for a in row] for row in split_lines if len(row)==4]
f.close()

for atoms in atom_list:
    old_name = atoms[1]
    new_name = atoms[0]
    date = atoms[2]
    description = atoms[3]
    sample_name_dict[(date, old_name)] = new_name

new_names = [atoms[0] for atoms in atom_list]
data_dict = {}
chromosomes = []
positions = []

# Extract data from each file; index according to new name
for i, file_name in enumerate(heights_files):
    f = open(file_name)
    
    # Determine date for sample
    date = file_name.split('_')[1].split('.txt')[0]
    
    # Determine old names for sample
    header_line = f.readline()
    old_sample_names = header_line.strip().split()[2:]
    data = [l.strip().split() for l in f.readlines() if len(l.strip().split()) > 2]

    # If first file, get chromosomes and positions
    if i==0:
        chromosomes = [atoms[0] for atoms in data]
        positions = [atoms[1] for atoms in data]
    
    # If not first file, check to make sure all chromosomes and positions match
    else:
        assert(len(chromosomes) == len(data)) # Just check length
        assert(len(positions) == len(data)) # Just check length

    num_positions = len(positions)

    # Index data in dictionary according to new name
    for j, old_name in enumerate(old_sample_names):
        key = (date, old_name)
        if key in sample_name_dict.keys():
            new_name = sample_name_dict[key]
            print('Loading data for sample %s...'%new_name)
            data_dict[new_name] = [atoms[j+2] for atoms in data]

# Write heights file containing all data
print('Saving data in %s...'%heights_all_file)
g = open(heights_all_file,'w')
header_atoms = ['chr','pos']
header_atoms.extend(new_names)
g.write('\t'.join(header_atoms)+'\n')
for n in range(len(positions)):
    atoms = [chromosomes[n], positions[n]]
    for name in new_names:
        atoms.append(data_dict[name][n])
    g.write('\t'.join(atoms)+'\n')
g.close()
print('Done!')

