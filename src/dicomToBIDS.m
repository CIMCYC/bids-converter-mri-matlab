function dicomToBIDS(cfg, dcm)
%% Raw directories:
% Retrieve the directories where the raw data to be converted are located.

dcmFolders = getDCMFolders(cfg);

for f = 1 : length(dcmFolders)
    %% Output directories:
    % Generate the output directories, both for the data and for the
    % derivatives if necessary.

    cfg = generateOutputDirectories(cfg, dcmFolders(f));

    %% Build the conversion command:
    % Build the command that will be executed via a system call.
    % We will call dcm2niix or spec2nii depending on the modality of the
    % data to be converted.

    command = generateCommand(cfg, dcm);

    %% Run the conversion command:
    % Make a system call to execute the previously generated command.

    runConversionCommand(cfg, command);

    %% Update taskName in sidecar JSON:
    % If task data are present, we must update the task name in the 
    % metadata JSON file to comply with the BIDS standard.

    updateTaskNameJSON(cfg, dcm);

    %% Phase data extra steps:
    % For phase reconstructions we must add the Units field to the
    % metadata JSON file to comply with the BIDS standard.

    updatePhaseUnitsJSON(cfg, dcm);

    %% Arterial Spin Labeling extra steps:
    % For Arterial Spin Labeling we must create the M0Type parameter in the 
    % metadata JSON file to comply with the BIDS standard.

    updateALSJSON(cfg, dcm); % Required parameters in the sidecar JSON.
    generateASLContextFile(cfg, dcm); % % Generate context file.

    %% Fiedmaps extra steps:
    % In some cases, it is necessary to rename the converted files.
    % For example, field maps require modification to comply with the BIDS 
    % standard.

    renameBIDSConvertedFiles(cfg,dcm);

end

end