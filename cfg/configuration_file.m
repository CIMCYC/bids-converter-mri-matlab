%% IMPORT CONFIGURATION FILE (import_configuration.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% BIDS - Subject ID:
% Description: Subject identifier. According to BIDS specification this
% identifier must include the prefix 'sub-' followed by an ID.

cfg.subject_id = 'sub-001';

%% BIDS - Session Name:
% Description: Identifier for the session name. In accordance with the BIDS 
% specification, it must include the prefix 'ses-' followed by the session 
% label.
%
% Note: If you do not want to include the session level in the BIDS 
% directory structure (e.g. single-session protocols), set this parameter 
% as an empty string. Otherwise, specify the desired session label 
% (e.g., 'ses-01').

cfg.session_id = '';

%% BIDS - Data format:
% Description: There are several data formats that can be selected in the 
% dcm2niix package:
%
% - 'n' for single nii uncompressed.
% - 'y' for single nii.gz compressed.
% - etc ...

cfg.data_format = 'y';

%% BIDS - Phase Units:
% Description: Units of the phase data stored in the JSON sidecar of phase
% images. Allowed values are:
%
% - 'arbitrary' for phase data in arbitrary units.
% - 'rad' for phase data in radians.

cfg.phaseUnits = 'arbitrary';

%% BIDS - Anonymization:
% Description: Delete personal information in JSON metadata (sex, name, id 
% date of birth, size, weight, age, etc):
%
% - 'n' for including personal information.
% - 'y' for removing personal information.

cfg.anonymization = 'y';

%% BIDS - Output directory:
% Description: Main directory of your BIDS compatible project.

cfg.bids_directory = '/Volumes/SSD/pruebas_resonancia/data/06-04-2026/bids';


cfg.generateBIDSIgnoreFile = true;

%% Root folder:
% Description: Folder containing the folders of the subjects:

cfg.root_folder = '/Volumes/SSD/pruebas_resonancia/data/06-04-2026/raw';

%% RAW - Extra files:
% Description: Import TSV files for the specified folder.

cfg.import_tsv = false;

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
%                   - 'swi': Susceptibility Weighted Imaging.
%               - For functional data:
%                   - 'bold': Functional data.
%                   - 'sbref': Single-band reference image
%               - For diffusion data:
%                   - 'dwi':  Diffusion data.
%                   - 'sbref': Single-band reference image
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
% - [optional] RECONSTRUCTION: The rec-<label> entity can be used to
%         distinguish different reconstruction algorithms.
% - [optional] FMAPID: For func/dwi data, label of the fmap that should be
%         applied to correct B0 inhomogeneities. The value is written to
%         the sidecar JSON as the BIDS "B0FieldSource" field, and must
%         match the "B0FieldIdentifier" defined for the corresponding fmap.
%         Example:
%               - dcm{i}.fmapid = 'fmap_run1';
% - [optional] IDENTIFIER: For fmap data, label that uniquely identifies
%         this fmap. The value is written to the phasediff sidecar JSON as
%         the BIDS "B0FieldIdentifier" field.
%         Example:
%               - dcm{i}.identifier = 'fmap_run1';
% - [optional] PART: The part-<label> entity is used to indicate which
%         component of the complex representation of the MRI signal is
%         represented in voxel data.
% - EVENTS:
%

%% ANAT: Anatomy imaging data:

% dcm{1}.folder = 't1_mprage_sag_iso_08_pat2_27*';
% dcm{1}.data_type = 'anat';
% dcm{1}.modality = 'T1w';
 
%% FUNC: Task (including resting state) imaging data:
% 
% dcm{2}.folder = 'Resting_cmrr_ep2d_bold_25mm_50sl_SMS2_TR1730_TE30_wphase_mag*';
% dcm{2}.data_type = 'func';
% dcm{2}.modality = 'bold';
% dcm{2}.task = 'rest';
% dcm{2}.part = 'mag';
% dcm{2}.fmapid = 'FMAP_PDIFF';

dcm{3}.folder = 'Resting_cmrr_ep2d_bold_25mm_50sl_SMS2_TR1730_TE30_wphase_pha*';
dcm{3}.data_type = 'func';
dcm{3}.modality = 'bold';
dcm{3}.task = 'rest';
dcm{3}.part = 'phase';

% dcm{4}.folder = 'Resting_cmrr_ep2d_bold_25mm_50sl_SMS2_TR1730_TE30_wphase_SBRef*';
% dcm{4}.data_type = 'func';
% dcm{4}.modality = 'sbref';
% dcm{4}.task = 'rest';
% 
% dcm{5}.folder = 'run1_cmrr_ep2d_bold_25mm_50sl_SMS2_TR1730_TE30_wphase_mag*';
% dcm{5}.data_type = 'func';
% dcm{5}.modality = 'bold';
% dcm{5}.task = 'faces';
% dcm{5}.part = 'mag';
% dcm{5}.run = '1';
% dcm{5}.fmapid = 'FMAP_PDIFF';

dcm{6}.folder = 'run1_cmrr_ep2d_bold_25mm_50sl_SMS2_TR1730_TE30_wphase_pha*';
dcm{6}.data_type = 'func';
dcm{6}.modality = 'bold';
dcm{6}.task = 'faces';
dcm{6}.part = 'phase';
dcm{6}.run = '1';

% dcm{7}.folder = 'run1_cmrr_ep2d_bold_25mm_50sl_SMS2_TR1730_TE30_wphase_sbref*';
% dcm{7}.data_type = 'func';
% dcm{7}.modality = 'sbref';
% dcm{7}.task = 'faces';
% dcm{7}.run = '1';
% 
% dcm{8}.folder = 'run2_cmrr_ep2d_bold_25mm_50sl_SMS2_TR1730_TE30_wphase_mag*';
% dcm{8}.data_type = 'func';
% dcm{8}.modality = 'bold';
% dcm{8}.task = 'faces';
% dcm{8}.part = 'mag';
% dcm{8}.run = '2';
% dcm{8}.fmapid = 'FMAP_PDIFF';

dcm{9}.folder = 'run2_cmrr_ep2d_bold_25mm_50sl_SMS2_TR1730_TE30_wphase_pha*';
dcm{9}.data_type = 'func';
dcm{9}.modality = 'bold';
dcm{9}.task = 'faces';
dcm{9}.part = 'phase';
dcm{9}.run = '2';

% dcm{10}.folder = 'run2_cmrr_ep2d_bold_25mm_50sl_SMS2_TR1730_TE30_wphase_sbref*';
% dcm{10}.data_type = 'func';
% dcm{10}.modality = 'sbref';
% dcm{10}.task = 'faces';
% dcm{10}.run = '2';

 
%% FMAP: Fieldmap data
% 
% dcm{11}.folder = 'gre_field_mapping_25mm_mag*';
% dcm{11}.data_type = 'fmap';
% dcm{11}.modality = 'fieldmap';
% 
% dcm{12}.folder = 'gre_field_mapping_25mm_pha*';
% dcm{12}.data_type = 'fmap';
% dcm{12}.modality = 'fieldmap';
% dcm{12}.identifier = 'FMAP_PDIFF';