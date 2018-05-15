#!/bin/sh

subdir='/DATA/236/dywu/HCP1200/data'
#subdir='/DATA/239/dywu/HCP_DTI/data_S500'
sublist=`ls $subdir`
sub=$1
ROI=ROI_surf2
resultdir=Diffusion.result.surf2.5k.gpu.matrix1

kk=0


for sub in $sublist; do

   kk=$((kk+1))
   if [ $kk -ge 51 ] && [ $kk -le 100 ] ; then

	
	roidir=$subdir/$sub/MNINonLinear/$ROI
	roilist=`ls $roidir/*.asc`
	#roilist="129.asc"
	#targetdir1=$subdir/$sub/MNINonLinear/ROI_vol82
	targetdir2=$subdir/$sub/MNINonLinear/ROI_surf210
	targetdir3=$subdir/$sub/MNINonLinear/ROI_surf380           #"/DATA/239/dywu/brainnetome_atlas/ROI_mask_resample.2mm_RPI"
	#ventricledir=$subdir/$sub/MNINonLinear/ROI_ventricle.2mm
	#targetlist1=`ls $targetdir1/* `
	targetlist2=`ls $targetdir2/*.asc `
	targetlist3=`ls $targetdir3/*.asc `
	#ventriclelist=`ls $ventricledir/* `

	#rm $subdir/$sub/T1w/target_list_surf590.2mm.txt	
	if [ ! -e $subdir/$sub/T1w/target_list_surf590.2mm.txt ]; then

	   for i in $targetlist2; do
		echo $i >> $subdir/$sub/T1w/target_list_surf590.2mm.txt
	   done
	
	   for i in $targetlist3; do
		echo $i >> $subdir/$sub/T1w/target_list_surf590.2mm.txt
	   done

	fi

	if [ ! -e $subdir/$sub/T1w/surf2.2mm.txt ]; then
	   	  
	   for i in $roilist; do
		echo $i >> $subdir/$sub/T1w/surf2.2mm.txt
	   done
	fi


	#if [ ! -e $subdir/$sub/T1w/avoid_ventricle.2mm.txt ]; then
	#   	  
	#   for i in $ventriclelist; do
	#	echo $i >> $subdir/$sub/T1w/avoid_ventricle.2mm.txt
	#   done
	#fi
	
	
	#rm -r $subdir/$sub/T1w/$resultdir
            if [ ! -e $subdir/$sub/T1w/$resultdir/fdt_matrix1.dot ]; then

		probtrackx2_gpu8 -x $subdir/$sub/T1w/surf2.2mm.txt  -V 1 -l --onewaycondition --loopcheck  -P 5000  \
		--xfm=$subdir/$sub/MNINonLinear/xfms/standard2acpc_dc.nii.gz  \
		--invxfm=$subdir/$sub/MNINonLinear/xfms/acpc_dc2standard.nii.gz \
		--meshspace=caret  \
		--seedref=$subdir/$sub/MNINonLinear/T1w_restore.2.nii.gz \
		--forcedir --opd -s $subdir/$sub/T1w/Diffusion.bedpostX/merged  \
		-m $subdir/$sub/T1w/Diffusion.bedpostX/nodif_brain_mask  \
		--dir=$subdir/$sub/T1w/$resultdir  --omatrix1\

	       
            fi

   fi
	
done
