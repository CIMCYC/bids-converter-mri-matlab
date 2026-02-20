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

cfg.sessionName = '';

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

cfg.outputDirectory = 'D:\marilo\bids';

cfg.generateDatasetDescriptionFile = true;
cfg.generateREADMEFile = true;
cfg.generateLicenseFile = true;
cfg.generateChangesFile = true;

%% RAW - DICOM directory:
% Description: Folder containing RAW data:

cfg.rawDICOM = 'D:\marilo\raw';
cfg.ip = 'Juanverdejo_Viorep - 1';

%% RAW - Extra files:
% Description: Import TSV files for the specified folder.

cfg.importTSV = false;

%% RAW DICOM folder list:
% Description: Cell array of folders containing the dcm files to convert.
% Please note that you must specify the following information for each
% set of DICOM files:
%
% - [required] FOLDER: Location of a set of dcm files to convert.
% - [required] DATA_TYPE: A functional group of different types of data. 
%              Examples: 
%               - 'anat': Anatomical data.
%               - 'func': Functional data.
%               - 'fmap': Field mapping data.
%               - 'dwi':  Diffusion data.
%               - 'mrs':  Magnetic Resonance Spectroscopy data.
%               - 'per':  Perfusion data.
%               - 'beh':  Behavioral data.
% - [required] MODALITY: The category of brain data recorded by a file. 
%              Examples:
%               - For anatomical data:
%                   - 'T1w':  T1-weighted data.
%                   - 'T2w':  T2-weighted data.
%                   - 'angio': Angiography data.
%               - For functional data:
%                   - 'bold': Functional data.
%               - For diffusion data:
%                   - 'dwi':  Diffusion data.
%               - For spectroscopy data:
%                   - 'svs':    Single-Voxel Spectroscopy data.
%                   - 'mrsi':   Magnetic resonance spectroscopic imaging.
%                   - 'unloc':  Unlocalized spectroscopy.
%                   - 'mrsref': Concentration or calibration reference.

% - [optional] TASK: A set of structured activities performed by the 
%         participant. Tasks are usually accompanied by stimuli and 
%         responses. The task-<label> MUST be consistent across subjects 
%         and sessions. Additionally, a common convention in the 
%         specification is to include the word 'rest' in the task label for 
%         resting state files (for example, task-rest) 
%         Examples: 
%               - 'task-mytaskname'
%               - 'task-rest': Recommended for resting state. 

% - [optional] DIRECTION: The dir-<label> entity can be set to an arbitrary 
%         alphanumeric label to distinguish different phase-encoding 
%         directions. 
%         Examples:
%               - 'dir-AP'
%               - 'dir-PA'
% - [optional] RUN: An uninterrupted repetition of data acquisition that 
%         has the same acquisition parameters and task. If your protocol is 
%         not divided into different runs, this field should be removed.
%         Example:
%               - 'run-1': Files corresponding to the first run.
%               - 'run-2': Files corresponding to the second run.
% - [optional] ACQUISITION: The acq-<label> entity corresponds to a custom 
%         label the user MAY use to distinguish a different set of 
%         parameters used for acquiring the same modality. For example, 
%         this should be used when a study includes two T1w images - one 
%         full brain low resolution and one restricted field of view but 
%         high resolution. 
%         Example:
%               - 'acq-highres'
%               - 'acq-lowres'
% - [optional] ECHO: This entity represents the "EchoTime" metadata field. 
%         Therefore, if the echo-<index> entity is present in a filename, 
%         "EchoTime" MUST be defined in the associated metadata. 
%         Please note that the <index> denotes the number/index (in the 
%         form of a nonnegative integer), not the "EchoTime" value of the 
%         separate JSON file.
% - EVENTS: 
%

%% ANAT: Anatomy imaging data:

dcm{1}.folder = 'T1*'; 
dcm{1}.dataType = 'anat';
dcm{1}.modality = 'T1w';

dcm{2}.folder = 't2_space_darkfluid_tra_p2_iso_2av*'; 
dcm{2}.dataType = 'anat';
dcm{2}.modality = 'T2w';
dcm{2}.acquisition = 'acq-darkfluid';

dcm{3}.folder = 't2_fl2d_tra_hemo*';
dcm{3}.dataType = 'anat';
dcm{3}.modality = 'T2w';
dcm{3}.acquisition = 'acq-hemo';

dcm{17}.folder = 'T2_5*';
dcm{17}.dataType = 'anat';
dcm{17}.modality = 'T2w';

% Angio

dcm{4}.folder = 'tof_fl3d_tra_p3_2slab_CUELLO_MIP_SAG*';
dcm{4}.dataType = 'anat';
dcm{4}.modality = 'angio';
dcm{4}.acquisition = 'acq-cuellosag';

dcm{5}.folder = 'tof_fl3d_tra_p3_2slab_CUELLO_MIP_COR*';
dcm{5}.dataType = 'anat';
dcm{5}.modality = 'angio';
dcm{5}.acquisition = 'acq-cuellocor';

dcm{6}.folder = 'tof_fl3d_tra_p3_2slab_CUELLO_17*';
dcm{6}.dataType = 'anat';
dcm{6}.modality = 'angio';
dcm{6}.acquisition = 'acq-cuello';

%% FUNC: Task (including resting state) imaging data:

dcm{7}.folder = 'ep2d_bold_p1_s4_resting_TR1500_PA*';
dcm{7}.dataType = 'func';
dcm{7}.modality = 'bold';
dcm{7}.task = 'task-rest';
dcm{7}.dir = 'dir-PA';

dcm{8}.folder = 'ep2d_bold_p1_s4_resting_TR1500_42*';
dcm{8}.dataType = 'func';
dcm{8}.modality = 'bold';
dcm{8}.task = 'task-rest';
dcm{8}.dir = 'dir-AP';

%% DWI: Diffusion imaging data

dcm{9}.folder = 'Diff_B2k_d60_blip*';
dcm{9}.dataType = 'dwi';
dcm{9}.modality = 'dwi';
dcm{9}.dir = 'dir-AP';
dcm{9}.acquisition = 'acq-b2000';

dcm{10}.folder = 'Diff_B1k_d32_blip*';
dcm{10}.dataType = 'dwi';
dcm{10}.modality = 'dwi';
dcm{10}.acquisition = 'acq-b1000';
dcm{10}.dir = 'dir-AP';

dcm{11}.folder = 'Diff_B300_d8_28*';
dcm{11}.dataType = 'dwi';
dcm{11}.modality = 'dwi';
dcm{11}.acquisition = 'acq-b300';
dcm{11}.dir = 'dir-PA';

dcm{12}.folder = 'Diff_B300_d8_blip*';
dcm{12}.dataType = 'dwi';
dcm{12}.modality = 'dwi';
dcm{12}.acquisition = 'acq-b300';
dcm{12}.dir = 'dir-AP';


%% FMAP: Fieldmap data

dcm{13}.folder = 'gre_field_mapping_25mm_60sl*';
dcm{13}.dataType = 'fmap';
dcm{13}.modality = 'fieldmap';

%% MRS: Magnetic Resonance Spectroscopy:

dcm{14}.folder = 'svs_se_30*';
dcm{14}.dataType = 'mrs';
dcm{14}.modality = 'svs';
dcm{14}.echo = 'echo-30';

dcm{15}.folder = 'svs_se_135*';
dcm{15}.dataType = 'mrs';
dcm{15}.modality = 'svs';
dcm{15}.echo = 'echo-135';  

%% PER: Perfusion: Arterial Spin Labeling (ALS)

dcm{16}.folder = 'tgse_pcasl_label1800ms_PLD1800ms*';
dcm{16}.dataType = 'perf';
dcm{16}.modality = 'asl';

% Extra information required. See your protocol file or ask to your RM 
% technician.
dcm{16}.M0Type = 'Absent'; % "Separate", "Included", "Estimate", "Absent".
dcm{16}.PostLabelingDelay = 1.8;
dcm{16}.BackgroundSuppression = false; % "true", "false".
dcm{16}.TotalAcquiredPairs = 10;