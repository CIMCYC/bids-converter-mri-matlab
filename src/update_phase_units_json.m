function update_phase_units_json(cfg,dcm)
%% Case 1:
% Folder explicitly marked as phase (dcm.part = 'phase'):

if isfield(dcm, 'part') && strcmp(dcm.part, 'phase')
    json_file = fullfile(cfg.out_folder, cfg.file_name + ".json");
end

%% Case 2:
% SBRef that also contains the phase volume. dcm2niix appends the _ph
% suffix to the phase file, so we check for its existence in the same way
% it is done in renameBIDSConvertedFiles.m for SBRef data.

if isfield(dcm, 'modality') && strcmp(dcm.modality, 'sbref')
    if isfield(cfg, 'file_name_phase_sbref')
        json_file = fullfile(cfg.out_folder, cfg.file_name_phase_sbref ...
            + ".json");
    end
end

%% Update JSON phase file:
if exist('json_file','var')

    % Fieds to add to the JSON file:
    fields.Units = dcm.phase_units;

    % Update JSON file:
    update_json(json_file,fields)
end

end
