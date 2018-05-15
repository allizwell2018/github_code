#!/bin/sh

scriptroot='/DATA/235/dywu/script'
#subdir='/DATA/239/dywu/HCP_DTI/data_S500'
subdir='/DATA/236/dywu/HCP1200/data'
sublist=`ls $subdir`
surface=white_MSMAll
ROI=ROI_surf380

labeldir='/DATA/235/dywu'
roidir=$scriptroot/ROI_surf380

#roilist=`cat /DATA/239/dywu/brainnetome_atlas/BN_Atlas_freesurfer_v6.0/BN210_labelname_surface.txt`
roilist_L=`cat /DATA/235/dywu/MMP.L.labelname.txt`
roilist_R=`cat /DATA/235/dywu/MMP.R.labelname.txt`

#i=1
#for roi in $roilist; do
	
#	roiname=`printf "%03d\n" $i`
#	wb_command -cifti-label-to-roi  $labeldir/fsaverage.BN_Atlas.32k_fs_LR.dlabel.nii   $roidir/${roiname}.dscalar.nii -name ${roi}
#	wb_command -cifti-create-dense-from-template $scriptroot/tstat1.dtseries.nii $roidir/${roiname}.dscalar.nii -cifti $roidir/${roiname}.dscalar.nii
#	i=$((i+1))
#	echo "$roi done"
#done

sub=$1
#for sub in $sublist; do
	i=1
	rm -r $subdir/$sub/MNINonLinear/$ROI
	mkdir -p $subdir/$sub/MNINonLinear/$ROI
	for roi in $roilist_L; do
		roiname=`printf "%03d\n" $i`
		wb_command -gifti-label-to-roi 	$labeldir/Q1-Q6_RelatedParcellation210.L.CorticalAreas_dil_Colors.32k_fs_LR.label.gii $subdir/$sub/MNINonLinear/$ROI/${roiname}.func.gii  -name ${roi}

		surf2surf -i $subdir/$sub/MNINonLinear/fsaverage_LR32k/$sub.L.$surface.32k_fs_LR.surf.gii -o $subdir/$sub/MNINonLinear/$ROI/${roiname}.asc  --values=$subdir/$sub/MNINonLinear/$ROI/${roiname}.func.gii  --outputtype=ASCII

		wb_command -cifti-create-dense-from-template  $scriptroot/tstat1.dtseries.nii $subdir/$sub/MNINonLinear/$ROI/${roiname}.dscalar.nii -metric CORTEX_LEFT  $subdir/$sub/MNINonLinear/$ROI/${roiname}.func.gii
		
		wb_command -cifti-convert -to-text $subdir/$sub/MNINonLinear/$ROI/${roiname}.dscalar.nii $subdir/$sub/MNINonLinear/$ROI/${roiname}.txt

		i=$((i+2))

	
	done
#done

#for sub in $sublist; do
	i=2
	for roi in $roilist_R; do
		roiname=`printf "%03d\n" $i`
		wb_command -gifti-label-to-roi 	$labeldir/Q1-Q6_RelatedParcellation210.R.CorticalAreas_dil_Colors.32k_fs_LR.label.gii $subdir/$sub/MNINonLinear/$ROI/${roiname}.func.gii  -name ${roi}

		surf2surf -i $subdir/$sub/MNINonLinear/fsaverage_LR32k/$sub.R.$surface.32k_fs_LR.surf.gii  -o $subdir/$sub/MNINonLinear/$ROI/${roiname}.asc  --values=$subdir/$sub/MNINonLinear/$ROI/${roiname}.func.gii  --outputtype=ASCII

		wb_command -cifti-create-dense-from-template  $scriptroot/tstat1.dtseries.nii $subdir/$sub/MNINonLinear/$ROI/${roiname}.dscalar.nii -metric CORTEX_RIGHT  $subdir/$sub/MNINonLinear/$ROI/${roiname}.func.gii

		wb_command -cifti-convert -to-text $subdir/$sub/MNINonLinear/$ROI/${roiname}.dscalar.nii $subdir/$sub/MNINonLinear/$ROI/${roiname}.txt

		i=$((i+2))
		
	
	done

#done

echo "$sub done"

