#!/bin/sh
#subdir='/DATA/239/dywu/HCP_DTI/data_S500'
subdir='/DATA/236/dywu/HCP1200/data'
sublist=`ls $subdir`
scriptdir='/DATA/235/dywu/script'
#scriptdir='/DATA/249/xli/HCP_DTI/script'

i=0

for sub in $sublist; do
	
	i=$((i+1))
	if [ $i -ge 1 ] && [ $i -le 10 ] ; then
	#if [ ! -e $subdir/$sub/MNINonLinear/Results/rfMRI_REST/merge_rfMRI.nii ]; then
	
		#fsl_sub  -q all.q -l $scriptdir/logdir $scriptdir/copy_files-resting.sh $sub
		#fsl_sub  -q short.q -l $scriptdir/logdirtemp $scriptdir/contactate_rfmri.sh $sub
		#fsl_sub  -q long.q -l $scriptdir/logdir $scriptdir/dualRegression.sh 
		#fsl_sub  -q all.q -l $scriptdir/logdir $scriptdir/make_roisurf2.sh $sub
		#fsl_sub  -q all.q -l $scriptdir/logdir $scriptdir/probtrack_surf210.sh $sub
		qsub  -e $scriptdir/logdir -o $scriptdir/logdir $scriptdir/probtrack_surf210.sh $sub
		#fsl_sub  -q short.q -l $scriptdir/logdir $scriptdir/convert_to_text.sh $sub
	fi
	
done
