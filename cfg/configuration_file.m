%% IMPORT CONFIGURATION FILE (configuration_file.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

%% RAW - Root folder:
% Description: Enter here the directory where the folders corresponding to 
% your participants containing the raw DICOM files are located. 
% Remember that the structure of this folder must be: 
% Directory > Subjects > Sessions

cfg.root_folder = '/Volumes/SSD/pruebas_resonancia/data/06-04-2026/raw';

%% BIDS - Output directory:
% Description: Enter here the directory where you want the dataset to be 
% saved after the conversion.

cfg.bids_directory = '/Volumes/SSD/pruebas_resonancia/data/06-04-2026/bids';

%% Sessions:
% Description: Specify in this parameter whether your experiment has 
% different sessions for each participant. If yes, the converter will 
% assume that each subfolder within the subject's folder corresponds to a 
% different session. If no, the converter will select the first subfolder 
% within the subject's folder as the folder to convert.

cfg.sessions = true;

%% Compress nifti files:
% Description: There are several data formats that can be selected in the 
% dcm2niix package:
%
% - 'n' for single nii uncompressed.
% - 'y' for single nii.gz compressed.
% - etc ...

cfg.data_format = 'y';

%% Metadata anonymization:
% Description: Delete personal information in JSON metadata (sex, name, id 
% date of birth, size, weight, age, etc):
%
% - 'n' for including personal information.
% - 'y' for removing personal information.

cfg.anonymization = 'y';

cfg.dcm2niix_path = '/Users/David/anaconda3/bin';
cfg.spec2nii_path = '/Users/David/anaconda3/bin';