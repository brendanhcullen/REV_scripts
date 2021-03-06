import os
from datetime import datetime
from bidsQC_classes import Sequence
from bidsQC_classes import TimePoint

######################## CONFIGURAGBLE PART BELOW ########################

# Set study info (change these for your study)
group = "sanlab"
study = "REV"

# Set directories for local testing
# bidsdir = os.path.join(os.sep, "Users", "kristadestasio", "Desktop", "bids_data")
# logdir = os.path.join(bidsdir, "logs_bidsQC")

# Set directories (Check these for your study)
# These variables are used in the main script and need to be defined here. 
# They need to exist prior to running the script.
logdir = os.path.join(os.getcwd(), 'logs_bidsQC')  # Where log files will go
bidsdir = os.path.join(os.sep, 'projects', group, 'shared', study, 'bids_data')  # Where your subjects' nifti directories are
tempdir = os.path.join(bidsdir, "tmp_dcm2bids2")
outputlog = os.path.join(logdir, "outputlog_bidsQC_" + datetime.now().strftime("%Y%m%d-%H%M") + ".txt")
errorlog = os.path.join(logdir, "errorlog_bidsQC_" + datetime.now().strftime("%Y%m%d-%H%M") + ".txt")
derivatives = os.path.join(bidsdir, "derivatives")



# Create a dictionary (the thing below) for each timepoint in your study where the pairs are "sequence_directory_name" : "expected_number_runs"
sequence1 = Sequence("func", {"bart": 1, "gng_acq-1":1, "gng_acq-2":1, "react_acq-1":1, "react_acq-2":1, "sst_acq-1":1, "sst_acq-2":1})
sequence2 = Sequence("func", {"bart": 1, "gng_acq-3":1, "gng_acq-4":1, "react_acq-3":1, "react_acq-4":1, "sst_acq-3":1, "sst_acq-4":1})
sequence3 = Sequence("anat", {"T1w":1})
sequence4 = Sequence("fmap", {"magnitude1":2, "magnitude2":2, "phasediff":2 })
timepoint1 = TimePoint("ses-wave1", [sequence1, sequence3, sequence4])
timepoint2 = TimePoint("ses-wave2", [sequence2, sequence3, sequence4])
expected_timepoints = [timepoint1, timepoint2]

# Files g-zipped or not? 
# NOTE: All files must be either zipped or unzipped. 
# A mixture won't work properly.
gzipped = True


# Do we want runs based on sequence order? Yes = True
# This is for tasks that use counterbalancing (of e.g. stimulus blocks) anf for which we want to identify the content
# with the 'acq-' label and order administered with the 'task-' label.
order_sequences = True
tasks_to_order = 'gng', 'react', 'sst'


# Paths that are required and that should not be changed
tempdir = os.path.join(bidsdir, 'tmp_dcm2bids')  # holding folder for undesired files
outputlog = os.path.join(logdir, 'outputlog_bidsQC' + datetime.now().strftime('%Y%m%d-%H%M%S') + '.txt')
errorlog = os.path.join(logdir, 'errorlog_bidsQC' + datetime.now().strftime('%Y%m%d-%H%M%S') + '.txt')
derivatives = os.path.join(bidsdir, 'derivatives')  # Where processed data will go
