#!/bin/bash

#########################################################################
# Script to move SST behavioral files from the directories they are in  #
# to the directories specified in the SST analysis REV_scripts 			#
# KD 2017.04.05															#
#########################################################################

# Import user from runscript
user=$(awk -F'"' '/^user=/ {print $2}' 0_runscript.sh ) #https://unix.stackexchange.com/questions/136151/how-do-i-get-a-variables-value-from-one-script-and-import-it-in-another-script

# Set paths
repopath="/Users/${user}/Desktop/REV_scripts"

# Set paths
outputdir="$repopath/behavioral/REV_SST/output"
sourcedir="/Users/${user}/Desktop/REV_BxData"
outputlog="$outputdir/outputlog_populate.txt"
errorlog="$outputdir/errorlog_populate.txt"
allsubs="$outputdir/subjectlist.txt"

# Check directory dependencies
if [ ! -d "${outputdir}" ]; then
	mkdir -v "${outputdir}"
fi

if [ ! -d "${outputdir}/train" ]; then
	mkdir -v "${outputdir}/train"
fi

if [ ! -d "${outputdir}/pre" ]; then
	mkdir -v "${outputdir}/pre"
fi

if [ ! -d "${outputdir}/post" ]; then
	mkdir -v "${outputdir}/post"
fi

if [ ! -d "${outputdir}/omitted" ]; then
	mkdir -v "${outputdir}/omitted"
fi

if [ ! -d "${outputdir}/analysisReady" ]; then
	mkdir -v "${outputdir}/analysisReady"
fi

if [ ! -d "${repopath}/behavioral/REV_SST/compiledResults" ]; then
	mkdir -v "${repopath}/behavioral/REV_SST/compiledResults"	
fi

if [ ! -d "${sourcedir}" ]; then
	echo "No directory at $sourcedir"
fi

# create output logs
touch "${outputlog}"
touch "${errorlog}"
touch "${allsubs}"

echo "Copying data from $sourcedir to $outputdir" > $outputlog
echo "Errors during copy data from $sourcedir to $outputdir" > $errorlog

# Create a text file of all participants in the behavioral data folder
cd $sourcedir/scanning
sublist=$(ls -d REV*)
for subject in ${sublist[@]}; do
	echo ${subject} >> $allsubs
done

# Copy behavioral data to the output folder
cd $sourcedir/training
for sub in ${sublist[@]}; do
	if [ -d $sub ]; then
		cd $sub
		if [ $(ls "${sourcedir}"/training/"${sub}"/*run*.mat | wc -l) -gt 0 ]; then
			for run in $(ls *run*.mat); do 
				cp $run $outputdir/train/$run
			done
			echo ${sub} "training runs copied" >> $outputlog
			cd ..
		else echo ${sub} "training runs do not exist" >> $errorlog	
		fi
	else echo ${sub} "training data directory does not exist" >> $errorlog	
	fi
done

cd $sourcedir/scanning
for sub in ${sublist[@]}; do
	if [ -d $sub ]; then
		cd $sub
		if [ -d base/SST ]; then
			cd base/SST
			if [ $(ls "${sourcedir}"/scanning/"${sub}"/base/SST/*.mat | wc -l) -gt 0 ]; then
				for baserun in $(ls *.mat); do
					cp $baserun $outputdir/pre/$baserun
				done
				echo ${sub} "base runs copied" >> $outputlog
			else echo ${sub} "base runs do not exist" >> $errorlog	
			fi
			cd ../..
		fi
		if [ -d end/SST ]; then
			cd end/SST
			if [ $(ls "${sourcedir}"/scanning/"${sub}"/end/SST/*.mat | wc -l) -gt 0 ]; then
				for endrun in $(ls *.mat); do
					cp $endrun $outputdir/post/$endrun
				done
				echo ${sub} "end runs copied" >> $outputlog
			else echo ${sub} "end runs do not exist" >> $errorlog	
			fi
			cd ../..
		fi
		cd ..
	else echo ${sub} "scanning data directory does not exist" >> $errorlog	
	fi
done

echo "done copying data"