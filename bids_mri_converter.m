%% BIDS CONVERTER (bids_converter.m)
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

run cfg/external_converters.m;
run cfg/dataset_description.m;
run cfg/configuration_file.m;

initialize_bids_dataset(cfg);

%% Get subject list:

subjects = get_subjects_list(cfg);

%% BIDS conversion routine:

start_bids_conversion(cfg,dcm,subjects);