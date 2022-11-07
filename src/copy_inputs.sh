#!/bin/bash

# From baxpr@github https://github.com/baxpr/example-spm-singularity-spider 
# Copy input files to the output/working directory so we don't mess them up. We
# generally assume the output directory starts out empty and will not be 
# interfered with by any other processes 

echo Running $(basename "${BASH_SOURCE}")

# Copy the input nifti files to the working directory (out_dir) with a hard-coded
# filename.
if [ ! -d "$out_dir" ]; then
	mkdir -p "$out_dir"
fi

cp -f "${fmri1_niigz}" "${out_dir}"/fmri1.nii.gz

cp -f "${confounds1}" "${out_dir}"/confounds1.tsv 

cp -f "${multi_conds1}" "${out_dir}"/onsets_foodpics1.mat 

if [ "${fmri2_niigz}" != "" ]; then
	cp -f "${fmri2_niigz}" "${out_dir}"/fmri2.nii.gz

	cp -f "${multi_conds2}" "${out_dir}"/onsets_foodpics2.mat

	cp -f "${confounds2}" "${out_dir}"/confounds2.tsv
fi

# Unzip files for SPM
gunzip -f "${out_dir}"/*.nii.gz

