%% IMPORT CONFIGURATION FILE (import_configuration.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% BIDS - Subject ID:
% Description: Subject identifier. According to BIDS specification this
% identifier must include the prefix 'sub-' followed by an ID.

cfg.subjectId = 'sub-001';

%% BIDS - Session Name:
% Description: Identifier for the session name. In accordance with the BIDS 
% specification, it must include the prefix 'ses-' followed by the session 
% label.
%
% Note: If you do not want to include the session level in the BIDS 
% directory structure (e.g. single-session protocols), set this parameter 
% as an empty string. Otherwise, specify the desired session label 
% (e.g., 'ses-01').

cfg.sessionName = 'ses-post';

%% BIDS - Data format:
% Description: There are several data formats that can be selected in the 
% dcm2niix package:
%
% - 'n' for single nii uncompressed.
% - 'y' for single nii.gz compressed.
% - etc ...

cfg.dataFormat = 'y';

%% BIDS - Output directory:
% Description: Main directory of your BIDS compatible project.

cfg.outputDirectory = '/Users/David/Desktop/bids';

cfg.generateDatasetDescriptionFile = true;
cfg.generateREADMEFile = true;
cfg.generateLicenseFile = true;
cfg.generateChangesFile = true;

%% RAW - DICOM directory:
% Description: Folder containing RAW data:

cfg.rawDICOM = ['/Users/David/Desktop/raw/NeBeexd_2/' ...
    'Alfonso_Caracuel_Rm - 1'];

%% RAW - Extra files:
% Description: Import TSV files for the specified folder.

cfg.importTSV = false;

%% RAW DICOM folder list:
% Description: Cell array of folders containing the dcm files to convert.
% Please note that you must specify the following information for each
% set of DICOM files:
%
% - FOLDER: Location of a set of dcm files to convert.
% - DATA_TYPE: A functional group of different types of data. Examples: 
%               - 'anat': Anatomical data.
%               - 'func': Functional data.
%               - 'fmap': Field mapping data.
%               - 'dwi':  Diffusion data.
%               - 'beh':  Behavioral data.
% - MODALITY: The category of brain data recorded by a file. Examples:
%               - 'T1w':  T1-weighted data.
%               - 'T2w':  T2-weighted data.
%               - 'bold': Functional data.
%               - 'dwi':  Diffusion data.
% - TASK: A set of structured activities performed by the participant.
%         Tasks are usually accompanied by stimuli and responses. The 
%         task-<label> MUST be consistent across subjects and sessions. 
%         Additionally, a common convention in the specification is to 
%         include the word 'rest' in the task label for resting state
%         files (for example, task-rest) Examples: 
%               - 'task-mytaskname'
%               - 'task-rest': Recommended for resting state. 
% - DIR: The dir-<label> entity can be set to an arbitrary alphanumeric 
%        label to distinguish different phase-encoding directions. 
%        Examples:
%               - 'dir-LR'
%               - 'dir-AP'
% - RUN: An uninterrupted repetition of data acquisition that has the same 
%        acquisition parameters and task. If your protocol is not divided 
%        into different runs, this field should be removed
%        Example:
%               - 'run-1': Files corresponding to the first run.
%               - 'run-2': Files corresponding to the second run.
% - EVENTS: 
%
%
%  (*) When applicable, the modality is indicated in the suffix

%% Functional
dcm{1}.folder = [cfg.rawDICOM filesep 'Rangeltask1*'];
dcm{1}.dataType = 'func';
dcm{1}.modality = 'bold';
dcm{1}.task = 'task-rangeltask1';
dcm{1}.events = 'events.tsv';

dcm{2}.folder = [cfg.rawDICOM filesep 'Rangeltask2*'];
dcm{2}.dataType = 'func';
dcm{2}.modality = 'bold';
dcm{2}.task = 'task-rangeltask2';
dcm{2}.events = 'events.tsv';

dcm{3}.folder = [cfg.rawDICOM filesep 'Rangeltask3*'];
dcm{3}.dataType = 'func';
dcm{3}.modality = 'bold';
dcm{3}.task = 'task-rangeltask3';
dcm{3}.events = 'events.tsv';

dcm{4}.folder = [cfg.rawDICOM filesep 'Go-no-go*'];
dcm{4}.dataType = 'func';
dcm{4}.modality = 'bold';
dcm{4}.task = 'task-gonogo';
dcm{4}.events = 'events.tsv';

dcm{5}.folder = [cfg.rawDICOM filesep 'Resting*'];
dcm{5}.dataType = 'func';
dcm{5}.modality = 'bold';
dcm{5}.task = 'task-rest';

%% Anatomical

dcm{6}.folder = [cfg.rawDICOM filesep 't1_mprage_sag_p2_1iso_MGH_6']; 
dcm{6}.dataType = 'anat';
dcm{6}.modality = 'T1w';

dcm{7}.folder = [cfg.rawDICOM filesep 't2_tse*']; 
dcm{7}.dataType = 'anat';
dcm{7}.modality = 'T2w';

%% Fieldmaps

dcm{8}.folder = [cfg.rawDICOM filesep 'gre_field_mapping_39*'];
dcm{8}.dataType = 'fmap';
dcm{8}.modality = 'fieldmap';

%% DTI

dcm{10}.folder = [cfg.rawDICOM filesep 'ep2d_diff_mgh_1_44*'];
dcm{10}.dataType = 'dwi';
dcm{10}.modality = 'dwi';






