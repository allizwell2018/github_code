#!/bin/sh

filedir='/DATA/235/dywu/HCP1200'
filelist=`ls $filedir/*.zip`
scriptdir='/DATA/235/dywu/script'


i=0

for file in $filelist; do

	#i=$((i+1))
	#if [ $i -ge 1 ] && [ $i -le 110 ] ; then
		
		fsl_sub  -q all.q -l $scriptdir/logdir $scriptdir/unzip_single.sh $file


	#fi
	
done
