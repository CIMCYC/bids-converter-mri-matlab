%% BIDS CONVERTER (bidsConverter.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

% This script converts the selected DICOMs to NIFTI files according to BIDS
% standard. For the conversion this script uses the dicm2niix package:
%
% - https://github.com/rordenlab/dcm2niix (REQUIRED)
%
% Please follow the Installation Instructions provided in the link.

clc
clear all
addpath('src/');

%% Initialization:
% Initialize the conversion process. This includes checking whether the
% packages required for the conversion are accessible from MATLAB, and
% initializing the configuration files for the dataset and the subject.

run cfg/datasetDescriptionJSON.m;
run cfg/configurationFile.m;
run cfg/dataConverters.m

initializeBIDSDataset(cfg, datasetDescription);

%% DICOM to NIFTI.
% Conversion routine:

for i = 1 : length (dcm)

    if ~isempty(dcm{i}) && ~isempty(dir(dcm{i}.folder))
        %% Output folder:
        % Define the output path so that it complies with the BIDS standard. The
        % hierarchy should be: Subject > Session > Data type.

        cfg.outFolder = [cfg.outputDirectory filesep cfg.subjectId ...
            filesep cfg.sessionName filesep dcm{i}.dataType];

        %% Generate BIDS-compatible filename:
        % This filename is generated based on the data provided for the
        % current folder (modality, task, run, events, etc.)

        [cfg.fileName, cfg.eventsFileName] = generateBIDSFileName(...
            cfg, dcm{i});

        %% Convert DICOM - NIFTI:
        % Conversion routine. Here we will make system calls that convert 
        % the raw DICOM data into NIfTI format with file names and a 
        % structure compatible with the BIDS standard.

        cfg.convertedFiles = dicomToBIDS(cfg, dcm{i});

        %% Import TSV:
        % If the data correspond to a task, we must also import the TSV 
        % files specifying the onset and duration of the events.

        importTSVFile(cfg, dcm{i});

    end

end