#!/bin/sh

scriptroot='/DATA/235/dywu/script'
#subdir='/DATA/239/dywu/HCP_DTI/data_S500'
subdir='/DATA/236/dywu/HCP1200/data'
sublist=`ls $subdir`

sub=$1

wb_command -cifti-convert -to-text  $subdir/$sub/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii $subdir/$sub/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_MSMAll_hp2000_clean.txt

wb_command -cifti-convert -to-text  $subdir/$sub/MNINonLinear/Results/rfMRI_REST1_RL/rfMRI_REST1_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii $subdir/$sub/MNINonLinear/Results/rfMRI_REST1_RL/rfMRI_REST1_RL_Atlas_MSMAll_hp2000_clean.txt

wb_command -cifti-convert -to-text  $subdir/$sub/MNINonLinear/Results/rfMRI_REST2_LR/rfMRI_REST2_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii $subdir/$sub/MNINonLinear/Results/rfMRI_REST2_LR/rfMRI_REST2_LR_Atlas_MSMAll_hp2000_clean.txt

wb_command -cifti-convert -to-text  $subdir/$sub/MNINonLinear/Results/rfMRI_REST2_RL/rfMRI_REST2_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii $subdir/$sub/MNINonLinear/Results/rfMRI_REST2_RL/rfMRI_REST2_RL_Atlas_MSMAll_hp2000_clean.txt
