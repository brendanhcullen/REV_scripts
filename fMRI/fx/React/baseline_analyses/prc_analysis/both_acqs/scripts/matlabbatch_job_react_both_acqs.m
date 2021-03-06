%-----------------------------------------------------------------------
% Job saved on 11-Dec-2018 10:37:57 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/REV/fmriprep_backup/2018.09.06_rev_fmriprep_backup/sub-REV001/ses-wave1/func'};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sub-REV001_ses-wave1_task-react_acq-1_run-.*_bold_space-MNI152NLin2009cAsym_preproc.nii.gz';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-REV001_ses-wave1_task-react_acq-1_run-.*_bold_space-MNI152NLin2009cAsym_preproc.nii.gz)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
matlabbatch{3}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
matlabbatch{3}.spm.util.exp_frames.frames = Inf;
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/REV/fmriprep_backup/2018.09.06_rev_fmriprep_backup/sub-REV001/ses-wave1/func'};
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sub-REV001_ses-wave1_task-react_acq-2_run-.*_bold_space-MNI152NLin2009cAsym_preproc.nii.gz';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-REV001_ses-wave1_task-react_acq-2_run-.*_bold_space-MNI152NLin2009cAsym_preproc.nii.gz)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
matlabbatch{6}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
matlabbatch{6}.spm.util.exp_frames.frames = Inf;
matlabbatch{7}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{7}.spm.spatial.smooth.fwhm = [4 4 4];
matlabbatch{7}.spm.spatial.smooth.dtype = 0;
matlabbatch{7}.spm.spatial.smooth.im = 0;
matlabbatch{7}.spm.spatial.smooth.prefix = 's';
matlabbatch{8}.spm.spatial.smooth.data(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.spm.spatial.smooth.fwhm = [4 4 4];
matlabbatch{8}.spm.spatial.smooth.dtype = 0;
matlabbatch{8}.spm.spatial.smooth.im = 0;
matlabbatch{8}.spm.spatial.smooth.prefix = 's';
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/REV/fmriprep_backup/2018.09.06_rev_fmriprep_backup/sub-REV001/ses-wave1/func'};
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sub-REV001_ses-wave1_task-react_acq-.*_run-01_bold_space-MNI152NLin2009cAsym_brainmask.nii.gz';
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{10}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-REV001_ses-wave1_task-react_acq-1_run-.*_bold_space-MNI152NLin2009cAsym_brainmask.nii.gz)', substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{10}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{10}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
matlabbatch{11}.spm.util.exp_frames.files(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
matlabbatch{11}.spm.util.exp_frames.frames = Inf;
matlabbatch{12}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/REV/fmriprep_backup/2018.09.06_auto_motion_output_backup/rp_txt'};
matlabbatch{12}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'rp_REV001_1_react_1.txt';
matlabbatch{12}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{13}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/REV/fmriprep_backup/2018.09.06_auto_motion_output_backup/rp_txt'};
matlabbatch{13}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'rp_REV001_1_react_2.txt';
matlabbatch{13}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{14}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/REV/REV_BxData/names_onsets_durations/react/PRC'};
matlabbatch{14}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sub-REV001_task-React_acq-1_onsets_.*.mat';
matlabbatch{14}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{15}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/sanlab/shared/REV/REV_BxData/names_onsets_durations/react/PRC'};
matlabbatch{15}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sub-REV001_task-React_acq-2_onsets_.*.mat';
matlabbatch{15}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{16}.spm.stats.fmri_spec.dir = {'/projects/sanlab/shared/REV/bids_data/derivatives/baseline_analyses/sub-REV001/fx/react/prc'};
matlabbatch{16}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{16}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{16}.spm.stats.fmri_spec.timing.fmri_t = 72;
matlabbatch{16}.spm.stats.fmri_spec.timing.fmri_t0 = 36;
matlabbatch{16}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{16}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{16}.spm.stats.fmri_spec.sess(1).multi(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-REV001_task-React_acq-1_onsets_.*.mat)', substruct('.','val', '{}',{14}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{16}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{16}.spm.stats.fmri_spec.sess(1).multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (rp_REV001_1_react_1.txt)', substruct('.','val', '{}',{12}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{16}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{16}.spm.stats.fmri_spec.sess(2).scans(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{16}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{16}.spm.stats.fmri_spec.sess(2).multi(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sub-REV001_task-React_acq-2_onsets_.*.mat)', substruct('.','val', '{}',{15}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{16}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{16}.spm.stats.fmri_spec.sess(2).multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (rp_REV001_1_react_2.txt)', substruct('.','val', '{}',{13}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{16}.spm.stats.fmri_spec.sess(2).hpf = 128;
matlabbatch{16}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{16}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
matlabbatch{16}.spm.stats.fmri_spec.volt = 1;
matlabbatch{16}.spm.stats.fmri_spec.global = 'None';
matlabbatch{16}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{16}.spm.stats.fmri_spec.mask(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{16}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{17}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{16}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%matlabbatch{17}.spm.stats.fmri_est.spmmat = '<UNDEFINED>';
matlabbatch{17}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{17}.spm.stats.fmri_est.method.Classical = 1;
