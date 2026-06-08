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
%               - 'perf': Perfusion data.
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
% - [optional] DERIVATIVES: Name of the derivatives pipeline that produced
%         this data. When present, the converted files are stored under
%         <bids_directory>/derivatives/<pipeline>/sub-XX/ses-YY/<data_type>/
%         instead of the raw data root, as required by the BIDS standard.
%         A dataset_description.json file is generated automatically inside
%         the pipeline folder the first time it is created.
%         Example:
%               - dcm{i}.derivatives = 'siemens-scanner';
% - [optional] DESC: The desc-<label> entity is the last entity before the
%         suffix and is used to distinguish different variants of the same
%         modality. It is typically used together with the DERIVATIVES
%         field to distinguish files produced by the same pipeline (e.g.
%         FA, ADC, TRACEW maps derived from a DWI acquisition).
%         Example:
%               - dcm{i}.desc = 'fa';
% - [optional] SOURCEDATA: Use this field for raw series that CANNOT be
%         converted to NIfTI (e.g. the Siemens diffusion TENSOR series).
%         When present, the DICOM folder is copied verbatim into
%         <bids_directory>/sourcedata/sub-XX/ses-YY/<data_type>/<value>/
%         and the dcm2niix conversion is skipped entirely (derivatives,
%         desc, modality, etc. are ignored). The value is the name of the
%         destination folder inside sourcedata.
%         Example:
%               - dcm{i}.sourcedata = 'tensor';
% - EVENTS:

%% ANAT: Anatomy imaging data:

dcm{1}.folder = 't1_mprage_sag_p2_1iso_MGH*';
dcm{1}.data_type = 'anat';
dcm{1}.modality = 'T1w';

dcm{2}.folder = 't2_tse_tra_448_p2_3mm*';
dcm{2}.data_type = 'anat';
dcm{2}.modality = 'T2w';

%% FUNC: Task (including resting state) imaging data:

dcm{3}.folder = 'Resting*';
dcm{3}.data_type = 'func';
dcm{3}.modality = 'bold';
dcm{3}.task = 'rest';
dcm{3}.fmapid = 'FMAP';

dcm{4}.folder = 'Rangeltask1*';
dcm{4}.data_type = 'func';
dcm{4}.modality = 'bold';
dcm{4}.import_empty_tsv = 'true';
dcm{4}.task = 'rangeltask1';
dcm{4}.fmapid = 'FMAP';

dcm{5}.folder = 'Rangeltask2*';
dcm{5}.data_type = 'func';
dcm{5}.modality = 'bold';
dcm{5}.import_empty_tsv = 'true';
dcm{5}.task = 'rangeltask2';
dcm{5}.fmapid = 'FMAP';

dcm{6}.folder = 'Rangeltask3*';
dcm{6}.data_type = 'func';
dcm{6}.modality = 'bold';
dcm{6}.import_empty_tsv = 'true';
dcm{6}.task = 'rangeltask3';
dcm{6}.fmapid = 'FMAP';

dcm{7}.folder = 'Gonogo*';
dcm{7}.data_type = 'func';
dcm{7}.modality = 'bold';
dcm{7}.import_empty_tsv = 'true';
dcm{7}.task = 'gonogo';
dcm{7}.fmapid = 'FMAP';

%% FMAP: Fieldmap data

dcm{8}.folder = 'gre_field_mapping*';
dcm{8}.data_type = 'fmap';
dcm{8}.modality = 'fieldmap';
dcm{8}.identifier = 'FMAP';

%% DWI: Scanner-derived diffusion maps (ADC, TRACEW, FA, ColFA)
% These are not raw DWI volumes but scalar/colour maps already computed by
% the Siemens scanner. They are stored under derivatives/dwi-reconstruction
% and distinguished from one another via the desc-<label> entity.

dcm{9}.folder = 'ep2d_diff_mgh_1_ADC*';
dcm{9}.data_type = 'dwi';
dcm{9}.modality = 'dwi';
dcm{9}.derivatives = 'dwi-reconstruction';
dcm{9}.desc = 'adc';

dcm{10}.folder = 'ep2d_diff_mgh_1_TRACEW*';
dcm{10}.data_type = 'dwi';
dcm{10}.modality = 'dwi';
dcm{10}.derivatives = 'dwi-reconstruction';
dcm{10}.desc = 'tracew';

dcm{11}.folder = 'ep2d_diff_mgh_1_FA*';
dcm{11}.data_type = 'dwi';
dcm{11}.modality = 'dwi';
dcm{11}.derivatives = 'dwi-reconstruction';
dcm{11}.desc = 'fa';

dcm{12}.folder = 'ep2d_diff_mgh_1_ColFA*';
dcm{12}.data_type = 'dwi';
dcm{12}.modality = 'dwi';
dcm{12}.derivatives = 'dwi-reconstruction';
dcm{12}.desc = 'colfa';

%% DWI:
% Raw

dcm{13}.folder = 'ep2d_diff_mgh_1*';
dcm{13}.data_type = 'dwi';
dcm{13}.modality = 'dwi';

%% SOURCEDATA: Non-convertible series (e.g. diffusion tensor)
% The TENSOR series cannot be converted to NIfTI, so it is copied verbatim
% into sourcedata/sub-XX/ses-YY/dwi/tensor/ in its original DICOM format.

dcm{14}.folder = 'ep2d_diff_mgh_1_TENSOR*';
dcm{14}.data_type = 'dwi';
dcm{14}.sourcedata = 'tensor';


%% BIDS - Phase Units:
% Description: Units of the phase data stored in the JSON sidecar of phase
% images. Allowed values are:
%
% - 'arbitrary' for phase data in arbitrary units.
% - 'rad' for phase data in radians.
% - 'Hz' for phase data in Hz.