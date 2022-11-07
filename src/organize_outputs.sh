#!/bin/bash


## Cleanup after matlab script

echo Running $(basename "${BASH_SOURCE}")

cd "${out_dir}"

## Gzip all outputs 
# gzip *.nii

## Gzip func data
gzip *fmri*.nii 

## convert spm ps to pdf
for psf_file in *.ps; do
 	pdf_file=`basename $psf_file .ps`
 	ps2pdf $psf_file $pdf_file.pdf
done
rm *.ps
