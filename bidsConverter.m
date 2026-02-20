%% BIDS CONVERTER (bidsConverter.m)
% -------------------------------------------------------------------------
% Brain, Mind and Behavioral Research Center - University of Granada.
% Contact: dlopez@ugr.es (David Lopez-Garcia)
% -------------------------------------------------------------------------

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

%% Get subject list:

subjects = getSubjectsList(cfg);

%% DICOM to NIFTI.
% Conversion routine:
for i = 1 : subjects.n
    cfg.subjectId = subjects.ids{i};

    for j = 1 : length (dcm)
        %% DICOM folder:
        % Original DICOM folder to convert:
        cfg.dicomFolder = [subjects.paths{i} filesep dcm{j}.folder];

        if ~isempty(dcm{j}) && ~isempty(dir(cfg.dicomFolder))
            %% Output folder:
            % Define the output path so that it complies with the BIDS
            % standard. The hierarchy should be:
            % Subject > Session > Data type.

            cfg.outFolder = [cfg.outputDirectory filesep cfg.subjectId ...
                filesep cfg.sessionName filesep dcm{j}.dataType];

            %% Generate BIDS-compatible filename:
            % This filename is generated based on the data provided for the
            % current folder (modality, task, run, events, etc.)

            cfg = generateBIDSFileName(cfg, dcm{j});

            %% Convert DICOM - NIFTI:
            % Conversion routine. Here we will make system calls that convert
            % the raw DICOM data into NIfTI format with file names and a
            % structure compatible with the BIDS standard.

            dicomToBIDS(cfg, dcm{j});

            %% Import TSV:
            % If the data correspond to a task, we must also import the TSV
            % files specifying the onset and duration of the events.

            importTSVFile(cfg, dcm{j});

        end
    end
end