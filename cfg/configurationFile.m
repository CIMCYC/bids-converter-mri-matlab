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

cfg.rawDICOM = ['D:\marilo\raw\Juanverdejo_Viorep - 1'];

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
%               - 'mrs':  Magnetic Resonance Spectroscopy data.
%               - 'beh':  Behavioral data.
% - MODALITY: The category of brain data recorded by a file. Examples:
%               - Anatomical:
%                   - 'T1w':  T1-weighted data.
%                   - 'T2w':  T2-weighted data.
%                   - 'angio':Angiography sequences focus on enhancing the contrast of blood vessels
%               - Functional:
%                   - 'bold': Functional data.
%               - Diffusion:
%                   - 'dwi':  Diffusion data.
%               - Spectroscopy:
%                   - 'svs':    Single-Voxel Spectroscopy data.
%                   - 'mrsi':   Magnetic resonance spectroscopic imaging.
%                   - 'unloc':  Unlocalized spectroscopy.
%                   - 'mrsref': Concentration or calibration reference.

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
% - ACQ: The acq-<label> entity corresponds to a custom label the user MAY 
%        use to distinguish a different set of parameters used for 
%        acquiring the same modality. For example, this should be used when 
%        a study includes two T1w images - one full brain low resolution 
%        and one restricted field of view but high resolution. 
%        Example:
%               - 'acq-highres'
%               - 'acq-lowres'
% - ECHO: This entity represents the "EchoTime" metadata field. Therefore, 
%         if the echo-<index> entity is present in a filename, "EchoTime" 
%         MUST be defined in the associated metadata. Please note that the 
%         <index> denotes the number/index (in the form of a nonnegative 
%         integer), not the "EchoTime" value of the separate JSON file.
% - EVENTS: 
%
%
%  (*) When applicable, the modality is indicated in the suffix

%% Functional

% dcm{1}.folder = [cfg.rawDICOM filesep 'Rangeltask1*'];
% dcm{1}.dataType = 'func';
% dcm{1}.modality = 'bold';
% dcm{1}.task = 'task-rangeltask1';
% dcm{1}.events = 'events.tsv';
% 
% dcm{2}.folder = [cfg.rawDICOM filesep 'Rangeltask2*'];
% dcm{2}.dataType = 'func';
% dcm{2}.modality = 'bold';
% dcm{2}.task = 'task-rangeltask2';
% dcm{2}.events = 'events.tsv';
% 
% dcm{3}.folder = [cfg.rawDICOM filesep 'Rangeltask3*'];
% dcm{3}.dataType = 'func';
% dcm{3}.modality = 'bold';
% dcm{3}.task = 'task-rangeltask3';
% dcm{3}.events = 'events.tsv';
% 
% dcm{4}.folder = [cfg.rawDICOM filesep 'Go-no-go*'];
% dcm{4}.dataType = 'func';
% dcm{4}.modality = 'bold';
% dcm{4}.task = 'task-gonogo';
% dcm{4}.events = 'events.tsv';
% 
% dcm{5}.folder = [cfg.rawDICOM filesep 'Resting*'];
% dcm{5}.dataType = 'func';
% dcm{5}.modality = 'bold';
% dcm{5}.task = 'task-rest';
% 
%% Anatomical
% Los directorios a convertir que contengan datos anatómicos deben
% especificarse aquí. Los parametros que pueden incluirse en esta modalidad
% son los siguientes:
% 
% dcm{-}.acquisition
% dcm{-}.run
% dcm{-}.echo

dcm{5}.folder = [cfg.rawDICOM filesep 'T1*']; 
dcm{5}.dataType = 'anat';
dcm{5}.modality = 'T1w';

dcm{6}.folder = [cfg.rawDICOM filesep 't2_space_darkfluid_tra_p2_iso_2av*']; 
dcm{6}.dataType = 'anat';
dcm{6}.modality = 'T2w';
dcm{6}.acquisition = 'acq-darkfluid';

dcm{7}.folder = [cfg.rawDICOM filesep 't2_fl2d_tra_hemo*'];
dcm{7}.dataType = 'anat';
dcm{7}.modality = 'T2w';
dcm{7}.acquisition = 'acq-hemo';

%% Angio
dcm{8}.folder = [cfg.rawDICOM filesep 'tof_fl3d_tra_p3_2slab_CUELLO_MIP_SAG*'];
dcm{8}.dataType = 'anat';
dcm{8}.modality = 'angio';
dcm{8}.acquisition = 'acq-cuellosag';

dcm{9}.folder = [cfg.rawDICOM filesep 'tof_fl3d_tra_p3_2slab_CUELLO_MIP_COR*'];
dcm{9}.dataType = 'anat';
dcm{9}.modality = 'angio';
dcm{9}.acquisition = 'acq-cuellocor';

dcm{10}.folder = [cfg.rawDICOM filesep 'tof_fl3d_tra_p3_2slab_CUELLO_17*'];
dcm{10}.dataType = 'anat';
dcm{10}.modality = 'angio';
dcm{10}.acquisition = 'acq-cuello';

%% Spectroscopy data:

dcm{11}.folder = [cfg.rawDICOM filesep 'svs_se_30*'];
dcm{11}.dataType = 'mrs';
dcm{11}.modality = 'svs';
dcm{11}.echo = 'echo-30';

dcm{12}.folder = [cfg.rawDICOM filesep 'svs_se_135*'];
dcm{12}.dataType = 'mrs';
dcm{12}.modality = 'svs';
dcm{12}.echo = 'echo-135';  

%% Arterial Spin Labeling

dcm{13}.folder = [cfg.rawDICOM filesep 'tgse_pcasl_label1800ms_PLD1800ms*'];
dcm{13}.dataType = 'perf';
dcm{13}.modality = 'asl';

% Extra information required. See your protocol file or ask to your RM 
% technician.
dcm{13}.M0Type = 'Absent'; % "Separate", "Included", "Estimate", "Absent".
dcm{13}.PostLabelingDelay = 1.8;
dcm{13}.BackgroundSuppression = false; % "true", "false".
dcm{13}.TotalAcquiredPairs = 10;





% dcm{13}.folder = [cfg.rawDICOM filesep 'svs_se_135*'];
% dcm{13}.dataType = 'mrs';
% dcm{13}.modality = 'svs';
% dcm{13}.echo = 'echo-135';  

% %% Fieldmaps
% 
% dcm{8}.folder = [cfg.rawDICOM filesep 'gre_field_mapping_33*'];
% dcm{8}.dataType = 'fmap';
% dcm{8}.modality = 'fieldmap';
% 
% %% DTI
% 
% dcm{9}.folder = [cfg.rawDICOM filesep 'ep2d_diff_mgh_1_38*'];
% dcm{9}.dataType = 'dwi';
% dcm{9}.modality = 'dwi';


