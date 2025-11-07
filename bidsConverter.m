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

%% Initialize dataset load configuration file:

run cfg/datasetDescriptionJSON.m;
run cfg/configurationFile.m;

initializeBIDSDataset(cfg, datasetDescription);


%% DICOM to NIFTI.
%  Conversion routine:

for i = 1 : length (dcm)

    if ~isempty(dcm{i}) && ~isempty(dir(dcm{i}.folder))
        %% Output folder:
        cfg.outFolder = [cfg.outputDirectory filesep cfg.subjectId ...
            filesep cfg.sessionName filesep dcm{i}.dataType];

        % cfg.derivativesFolder = [cfg.outputDirectory filesep  ...
        %     'derivatives' filesep cfg.subjectId filesep cfg.sessionName ...
        %     filesep dcm{i}.dataType];

        %% Generate BIDS-compatible filename:
        % This filename is generated based on the data provided for the
        % current folder.

        [cfg.fileName, cfg.eventsFileName] = generateBIDSFileName(...
            cfg, dcm{i});

        %% Convert DICOM - NIFTI:
        cfg.convertedFiles = dicomToBIDS(cfg, dcm{i});

        %% Import TSV if needed:
        % Description:
        importTSVFile(cfg, dcm{i});

    end

end
