#!/bin/sh

scriptroot='/DATA/239/dywu/HCP_DTI/script'
subdir='/DATA/239/dywu/HCP_DTI/data_40'
outdir='/DATA/239/dywu/HCP_DTI/dti_predict_fmri_surf/dti'
ROI=ROI_surf210
roidir=$subdir/100307/MNINonLinear/$ROI
resultdir=Diffusion.result.surf210

sublist=`ls $subdir`
roilist=`ls $roidir/*.asc`
#roilist="108.asc"

for roi in $roilist;do
	roi=`basename $roi .asc`
	for sub in $sublist;do
		mkdir -p $outdir/$roi/$sub
		#cp $subdir/$sub/T1w/$resultdir/$roi/matrix_seeds_to_all_targets   $outdir/$roi/$sub/matrix_seeds_to_all_targets
		cp $subdir/$sub/MNINonLinear/$ROI/${roi}.txt $outdir/$roi/$sub/${roi}.txt


		#cp $subdir/$sub/T1w/$resultdir/$roi/fdt_matrix1.dot   $outdir/$roi/$sub/fdt_matrix1.dot		
		
		#cp $subdir/$sub/MNINonLinear/$ROI/${roi}.nii.gz $outdir/$roi/$sub/${roi}.nii.gz
		#fslchfiletype NIFTI $outdir/$roi/$sub/${roi}.nii.gz
	done
echo "$roi done"
done


