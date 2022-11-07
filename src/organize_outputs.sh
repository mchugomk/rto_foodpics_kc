#!/bin/bash


## Cleanup after matlab script

echo Running $(basename "${BASH_SOURCE}")

cd "${out_dir}"


## Gzip all outputs 
# gzip *.nii


## Move files into sensibly named directories

# functional data and additional files
mkdir func
mv *fmri*.nii func
mv *confounds*.tsv func
mv *.txt func

# Gzip func data
gzip func/*.nii 

# onsets
mkdir onsets
mv *onsets*.mat onsets

# SPM outputs
mkdir spm
# mv *.nii.gz spm
mv *.nii spm
mv SPM.mat spm

# save spm batch
mkdir batch
mv *batch.mat batch

# convert spm ps to pdf
mkdir pdf
# # sudo apt-get install ghostscript
for psf_file in *.ps; do
 	pdf_file=`basename $psf_file .ps`
 	ps2pdf $psf_file $pdf_file.pdf
done
mv *.pdf pdf
rm *.ps


