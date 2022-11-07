#!/bin/bash

## Primary script for foodpics spm12 first level analysis pipeline. 
#	Parses the command line arguments and exports as environment variables 
# 	Use baxpr@github style pipeline 
# 
# Example usage:
# 
# foodpics_firstlevel_main.sh \
#	--fmri1_niigz /path/to/fmri1.nii.gz \
#	--fmri2_niigz /path/to/fmri2.nii.gz \
# 	--confounds1 /path/to/confounds1.tsv \
# 	--confounds2 /path/to/confounds2.tsv \
# 	--multi_conds1 /path/to/onsets_foodpics_run1.mat \
# 	--multi_conds2 /path/to/onsets_foodpics_run2.mat \
#	--tr 2 \
#	--n_vols 172 \
#	--fwhm 6 \
#	--out_dir "../OUTPUTS"
#


## Main shell script for pipeline. We'll call the matlab part from here.

echo Running $(basename "${BASH_SOURCE}")


# Initialize defaults for any input parameters where that seems useful
# export mcr_dir=/usr/local/MATLAB/MATLAB_Runtime/v97
export mcr_dir=/data/analysis/maureen/software/MATLAB/MATLAB_Runtime/v97 # bk path
export out_dir="../OUTPUTS"
export n_vols="Inf" # test



# Parse input options
while [[ $# -gt 0 ]]
do
    case "$1" in

        --fmri1_niigz)
            # Full path and filename to input functional image 1
            export fmri1_niigz="$2"; shift; shift ;;

        --fmri2_niigz)
            # Full path and filename to input functional image 2
            export fmri2_niigz="$2"; shift; shift ;;

        --confounds1)
            # Full path and filename to fmriprep confounds for functional image 1
            export confounds1="$2"; shift; shift ;;

        --confounds2)
            # Full path and filename to fmriprep confounds for functional image 2
            export confounds2="$2"; shift; shift ;;

        --multi_conds1)
            # Full path and filename to multiple conditions file for functional image 1
            export multi_conds1="$2"; shift; shift ;;

        --multi_conds2)
            # Full path and filename to multiple conditions file for functional image 2
            export multi_conds2="$2"; shift; shift ;;

		--tr)
            # Repetition time for functional images
            export tr="$2"; shift; shift ;;

		--n_vols)
            # Number of volumes in functional image
            export n_vols="$2"; shift; shift ;;

		--fwhm)
            # FWHM of smoothing kernel
            export fwhm="$2"; shift; shift ;;

        --out_dir)
            # Where outputs will be stored. 
            export out_dir="$2"; shift; shift ;;
            
		*)
			# Handle any unrecognized options
            echo "Input ${1} not recognized"
            shift ;;

    esac
done


# Copy inputs to the working directory
 . copy_inputs.sh


# Run main matlab code 
# May need to update this after compiling matlab
if [ "${fmri2_niigz}" != "" ]; then
	../matlab/bin/run_spm12.sh "${mcr_dir}" function foodpics_firstlevel \
		fmri1_nii "${out_dir}"/fmri1.nii \
		fmri2_nii "${out_dir}"/fmri2.nii \
		confounds1 "${out_dir}"/confounds1.tsv \
		confounds2 "${out_dir}"/confounds2.tsv \
		multi_conds1 "${out_dir}"/onsets_foodpics1.mat \
		multi_conds2 "${out_dir}"/onsets_foodpics2.mat \
		tr "${tr}" \
		n_vols "${n_vols}" \
		fwhm "${fwhm}" \
		out_dir "${out_dir}"
else
	../matlab/bin/run_spm12.sh "${mcr_dir}" function foodpics_firstlevel \
		fmri1_nii "${out_dir}"/fmri1.nii \
		confounds1 "${out_dir}"/confounds1.tsv \
		multi_conds1 "${out_dir}"/onsets_foodpics1.mat \ 
		tr "${tr}" \
		n_vols "${n_vols}" \
		fwhm "${fwhm}" \
		out_dir "${out_dir}"
fi

## Organize outputs
. organize_outputs.sh

