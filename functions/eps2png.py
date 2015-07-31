#!/usr/bin/python
import os, sys
import glob

# Get user feedback
print 'Running eps2png.py'

# Get file pattern from user
file_pattern = sys.argv[1:]

# Compile all files that satisfy that pattern
file_names = glob.glog(file_pattern)

for file_name in file_names:
	# Give user feedback
	print 'Processing ' + file_name + '...'

	# Split file name into base and extension
	base, extension = os.path.splitext(file_name)

	# Make sure file is an eps file
	assert(extension=='eps')

	# Specify names of files involved
	eps_file = base+'.eps'
	pdf_file = base+'.pdf'
	png_file = base+'.png'

	# Convert eps to pdf and remove eps
	assert(os.path.exists(eps_file))				
	command1 = '/usr/texbin/epstopdf %s'%eps_file
	os.system(command1)
	
	# Convert pdf to png
	assert(os.path.exists(pdf_file))
	command2 = '/usr/bin/sips -s format png %s.pdf --out %s.png'%(base,base)
	os.system(command2)
	
	# Verify that png file was created then remove intermediate files
	assert(os.path.exists(png_file))
	os.remove(eps_file)
	os.remove(pdf_file)

print 'Done!'
