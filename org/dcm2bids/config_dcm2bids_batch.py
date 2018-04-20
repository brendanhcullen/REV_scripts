# Configuration file for dcm2bids_batch.py

import os

# Set study info (may need to change for your study)
group = "sanlab"
study = "REV"

gitrepo = "REV_scripts" # Parent folder that contains your org ("organization") and dcm2bids folders. If your directory structure is different, you'll have to adjust.
dicomdir = os.path.join(os.sep, "projects", "lcni", "dcm", group, "Archive", study)

# Set directories
niidir = os.path.join(os.sep, "projects", group, "shared", study, "bids_data") # Where the niftis will be put
codedir = os.path.join(os.sep, "projects", group, "shared", study, gitrepo, "org", "dcm2bids")  # Contains subject_list.txt, config file, and dcm2bids_batch.py
configfile = os.path.join(codedir, study + "_config.json")  # path to and name of config file
image = os.path.join(os.sep, "projects", group, "shared", "containers", "Dcm2Bids-master.simg")
logdir = os.path.join(codedir, "logs_dcm2bids")

outputlog = os.path.join(logdir, "outputlog_dcmn2bids.txt")
errorlog = os.path.join(logdir, "errorlog_dcm2bids.txt")

# Source the subject list (needs to be in your current working directory)
subjectlist = "subject_list.txt"