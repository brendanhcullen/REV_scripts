# Set working directory
#working_dir = "/projects/sanlab/shared/REV/bids_data/derivatives/fmriprep"
working_dir = "/projects/sanlab/shared/REV/fmriprep_backup/2018.09.06_rev_fmriprep_backup"
setwd(working_dir)

# Set output directory
#output_dir = "/Users/brendancullen/Desktop/motion/"
output_dir = "/projects/sanlab/shared/REV/bids_data/derivatives/motion/"

# Get a list of all the confounds.tsv files
confound_pattern = "*confounds*.tsv"
confounds_paths = list.files(working_dir, pattern = confound_pattern, full.names = TRUE, recursive = TRUE)

library(magrittr)
library(dplyr)

# Import the confounds.tsv files
for (path in confounds_paths) {
    # Import the confounds.tsv file
    confounds_file <- rio::import(path)
    # Select only the motion paramters of interest
    #new_confounds_file <- dplyr::select(confounds_file, c(X, Y, Z, RotX, RotY, RotZ, stdDVARS, FramewiseDisplacement)) %>%
    new_confounds_file <- dplyr::select(confounds_file, c(FramewiseDisplacement)) %>% # only select Framewise Displacement
      #convert NA's in FramewiseDisplacement and stdVARS to 0's
      mutate(FramewiseDisplacement = (as.numeric(ifelse(FramewiseDisplacement %in% "n/a", NA, FramewiseDisplacement)))) %>%
      mutate(FramewiseDisplacement = ifelse(is.na(FramewiseDisplacement), 0, FramewiseDisplacement))
      #mutate(stdDVARS = (as.numeric(ifelse(stdDVARS %in% "n/a", NA, stdDVARS)))) %>%
      #mutate(stdDVARS = ifelse(is.na(stdDVARS), 0, stdDVARS))
    # export to .txt
    new_file_name <- paste0(substr(path, 1, nchar(path) - 3), "txt") # change .tsv extension to .txt
    new_file_path <- paste0(output_dir, strsplit(new_file_name, "func/")[[1]][2]) # extract just the file name from the path name and join it with a new path name pointing to a "motion" directory
   write.table(new_confounds_file, new_file_path, sep = "\t", row.names = FALSE, col.names = FALSE)
}

