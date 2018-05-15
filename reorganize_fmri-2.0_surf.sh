#!/bin/sh

scriptroot='/DATA/235/dywu/script'
subdir='/DATA/236/dywu/HCP1200/data'
outdir='/DATA/236/dywu/HCP1200/dti_predict_fmri_surf/fmri'

smooth=2

sublist=`ls $subdir`

TaskNameList=""
TaskNameList="${TaskNameList} EMOTION"
TaskNameList="${TaskNameList} GAMBLING"
TaskNameList="${TaskNameList} LANGUAGE"
TaskNameList="${TaskNameList} MOTOR"
TaskNameList="${TaskNameList} RELATIONAL"
TaskNameList="${TaskNameList} SOCIAL"
TaskNameList="${TaskNameList} WM"

		
for TaskName in ${TaskNameList};do	
	copelist=`ls $subdir/100307/MNINonLinear/Results/tfMRI_$TaskName/tfMRI_"$TaskName"_hp200_s"$smooth"_level2_MSMAll.feat/GrayordinatesStats`
	for cope in $copelist; do
	    cope=`basename $cope .feat`
	    #if [ $cope != mask.nii.gz ] ; then
		#fslchfiletype NIFTI $groupfmridir/$TaskName/"$cope".gfeat/cope1.feat/stats/tstat1.nii.gz

		for sub in $sublist;do
			mkdir -p $outdir/$TaskName/$cope/$sub		
			
			#cp $subdir/$sub/MNINonLinear/Results/tfMRI_$TaskName/tfMRI_"$TaskName"_hp200_s"$smooth"_level2_MSMAll.feat/GrayordinatesStats/"$cope".feat/tstat1.dtseries.nii   $outdir/$TaskName/$cope/$sub/tstat1.dtseries.nii
			#cp $subdir/$sub/MNINonLinear/Results/tfMRI_$TaskName/tfMRI_"$TaskName"_hp200_s"$smooth"_level2_MSMAll.feat/GrayordinatesStats/"$cope".feat/zstat1.dtseries.nii   $outdir/$TaskName/$cope/$sub/zstat1.dtseries.nii
			wb_command -cifti-convert -to-text $subdir/$sub/MNINonLinear/Results/tfMRI_$TaskName/tfMRI_"$TaskName"_hp200_s"$smooth"_level2_MSMAll.feat/GrayordinatesStats/"$cope".feat/tstat1.dtseries.nii     $outdir/$TaskName/$cope/$sub/tstat1.txt
			wb_command -cifti-convert -to-text $subdir/$sub/MNINonLinear/Results/tfMRI_$TaskName/tfMRI_"$TaskName"_hp200_s"$smooth"_level2_MSMAll.feat/GrayordinatesStats/"$cope".feat/zstat1.dtseries.nii     $outdir/$TaskName/$cope/$sub/zstat1.txt

		done
	    #fi
		echo "$TaskName $cope done"
	done
done


