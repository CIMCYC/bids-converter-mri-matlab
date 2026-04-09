function dicom_to_bids(cfg,dcm)

%% Output directories:
% Generate the output directories, both for the data and for the
% derivatives if necessary.

cfg = generate_output_directories(cfg);

%% Build the conversion command:
% Build the command that will be executed via a system call.
% We will call dcm2niix or spec2nii depending on the modality of the
% data to be converted.

command = generate_conversion_command(cfg, dcm);

%% Run the conversion command:
% Make a system call to execute the previously generated command.

run_conversion_command(cfg, command);

%% Rename files:
% In some cases, it is necessary to rename the converted files.
% For example, field maps and phase files require modification to comply 
% with the BIDS standard.

rename_bids_converted_files(cfg,dcm);

%% Update taskName in sidecar JSON:
% If task data are present, we must update the task name in the
% metadata JSON file to comply with the BIDS standard.

update_taskname_json(cfg, dcm);

%% Phase data extra steps:
% For phase reconstructions we must add the Units field to the
% metadata JSON file to comply with the BIDS standard.

update_phase_units_json(cfg, dcm);

%% Arterial Spin Labeling extra steps:
% For Arterial Spin Labeling we must create the M0Type parameter in the
% metadata JSON file to comply with the BIDS standard.

update_als_json(cfg, dcm); % Required parameters in the sidecar JSON.
generate_asl_context_file(cfg, dcm); % % Generate context file.

%% B0 field mapping extra steps:
% For func/dwi data we add the B0FieldSource field to the sidecar JSON
% when an fmap identifier is provided. For fmap data we add the
% B0FieldIdentifier field to the phasediff sidecar JSON.

update_b0_field_json(cfg, dcm);


end