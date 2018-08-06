# Replace wrong-sized bids_data files with correct-sized tmp files

# Get list of full file paths for tmp files and bids files

# repopath="/Users/brendancullen/Desktop/REV/REV_scripts/org/dcm2bids"
repopath="/projects/sanlab/shared/REV/REV_scripts/org/dcm2bids"
bids_paths=`cat $repopath/file_size_bids_paths.txt`
tmp_paths=`cat $repopath/file_size_tmp_paths.txt`
bids_files=`cat $repopath/file_size_bids_files.txt`
tmp_files=`cat $repopath/file_size_tmp_files.txt`
declare -a tmp_paths_array
readarray -t tmp_paths_array < $repopath/file_size_tmp_paths.txt
declare -a tmp_files_array
readarray -t tmp_files_array < $repopath/file_size_tmp_files.txt
declare -a bids_files_array
readarray -t bids_files_array < $repopath/file_size_bids_files.txt
purgatory_path = "/projects/sanlab/shared/REV/purgatory"

#outputlog="$repopath/outputlog_fixFileSizes.txt"

# create output logs
#touch "${outputlog}"

# Idiosyncratic file renaming to correct naming errors
#echo "-------------------Renaming GNG files-------------------" > $outputlog
#cd $outputdir
#mv REV13_REV_GNG4.txt_04-May-2015_10-25.mat REV013_REV_GNG4.txt_04-May-2015_10-25.mat
#echo "REV13_REV_GNG4.txt_04-May-2015_10-25.mat REV013_REV_GNG4.txt_04-May-2015_10-25.mat" >> $outputlog


cd $repopath

num=`grep -c $ file_size_bids_paths.txt`

for i in $(seq 1 $num); do
path=${tmp_paths_array[i]}
oldfile=${tmp_files_array[i]}
newfile=${bids_files_array[i]}
if [ -d $path ]; then
cd $path


if [ -f $oldfile ]; then #file exists in folder
# mv $oldfile ${purgatory_path}/$newfile
echo $oldfile
echo 'will be renamed as'
echo ${purgatory_path}/$newfile
fi

cd ..
fi
done


for value in file_size_bids_paths.txt; do
echo $value
done

for value in $1/file_size_bids_paths.txt; do
echo $name
done


for i in $( ls ); do
            echo item: $i
        done

# Rename all GNG files to format ID_run
for file in $(ls *.mat)
    do
        new=$(echo "$file" | sed -E 's/_REV//')
        mv $file $new
done

for file in $(ls *.mat)
    do
        new=$(echo "$file" | sed -E 's/.{22}\.mat/.mat/')
        mv $file $new
done


# Move all the files to a 'purgatory' folder 

## for each file in bids_files, move file to new directory called "purgatory"

# For each file in purgatory, chop the file name (using string split) to exlcude the run number and add wild card, e.g. REV003_ses-wave1_task-gng_acq-1*.nii.gz
## save a list of these wild card names

# cd into bids_data folder 

# for each wild card name, search recursively through bids_data folder, get the bids_data file name, replace the file in purgatory folder with this file name, then move the bids_data file into `tmp_dcm2bids`

# for each re-named purgatory file, move the file to bids_path folder


## GENERAL NOTE: MAKE SURE YOU CHECK THE NOTES IN THE FOLLOWING GOOGLE SHEET TO MAKE SURE YOU ACCOUNT FOR THE FEW CASES THAT WERE MISNAMED
# https://docs.google.com/spreadsheets/d/1AXgCxuoqd-vQo6LJVRDfbUmjEf0OQpV3eZ5AXC9pkNM/edit#gid=0