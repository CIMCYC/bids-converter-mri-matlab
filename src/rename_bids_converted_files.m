function cfg = rename_bids_converted_files(cfg, dcm)

switch cfg.data_format
    case 'y', ext = ".nii.gz";
    case 'n', ext = ".nii";
    otherwise, ext = "";
end


%% Rename fmap files:
if strcmp(dcm.data_type,'fmap')

    json_files = dir(fullfile(cfg.out_folder, cfg.file_name + "*.json"));

    for file = json_files'
        % Determine new file name based on suffix
        if endsWith(file.name, '_ph.json')
            new_base = cfg.file_name + "_phasediff";
        elseif endsWith(file.name, '_e1.json')
            new_base = cfg.file_name + "_magnitude1";
        elseif endsWith(file.name, '_e2.json')
            new_base = cfg.file_name + "_magnitude2";
        else
            continue; % Skip if suffix is unknown
        end

        % Remove duplicated characters:
        new_base = remove_duplicate_char(new_base, '_');

        % Define paths to the old files:
        old_json_path = fullfile(file.folder, file.name);
        old_nii_path = old_json_path(1:end-5) + ext;

        % Define paths to the renamed files:
        new_json_path = fullfile(file.folder, new_base + ".json");
        new_nii_path = fullfile(file.folder, new_base + ext);

        % Rename the files:
        movefile(old_json_path, new_json_path);
        movefile(old_nii_path, new_nii_path);

        fprintf(['      > Renamed fieldmap files. \n']);

    end
end

%% Rename phase series:
% When converting the phase of the signal instead of the magnitude,
% dcm2niix always adds the _ph prefix to the converted file. This is not
% BIDS compatible, since the phase is encoded in the part-pha entity of
% the file_name.

if isfield(dcm,'part') && strcmp(dcm.part,'phase')

    % Define paths to the old files:
    old_json_path = fullfile(cfg.out_folder, cfg.file_name + "_ph.json");
    old_nii_path = fullfile(cfg.out_folder, cfg.file_name + "_ph" + ext);

    % Define paths to the renamed files:
    new_json_path = fullfile(cfg.out_folder, cfg.file_name + ".json");
    new_nii_path = fullfile(cfg.out_folder, cfg.file_name + ext);

    % Rename the files:
    movefile(old_json_path, new_json_path);
    movefile(old_nii_path, new_nii_path);

    fprintf(['      > Renamed phase series files. \n']);

end

%% Rename SBRef images:
% When the phase is also stored, the SBRef folder contains two volumes,
% one for the magnitude and one for the phase. If dcm2niix finds both
% images, it converts them and appends the _ph suffix to the phase file.

if strcmp(dcm.modality,'sbref')

    % Look for the file with the _ph suffix. If we find it we can assume
    % that the phase is being stored; otherwise, we assume it is not and
    % we do not need to do anything:

    phase_file = fullfile(cfg.out_folder, cfg.file_name + "_ph" + ext);

    if exist(phase_file, "file")
        %% MAGNITUDE FILES:

        % Build the new name for the magnitude file:
        dcm.part = 'mag';
        cfg_ = generate_bids_filename(cfg,dcm);

        % Define paths to the old files:
        old_json_path = fullfile(cfg.out_folder, cfg.file_name + ".json");
        old_nii_path = fullfile(cfg.out_folder, cfg.file_name  + ext);

        % Define paths to the renamed files:
        new_json_path = fullfile(cfg.out_folder, cfg_.file_name + ".json");
        new_nii_path = fullfile(cfg.out_folder, cfg_.file_name + ext);

        % Rename the files:
        movefile(old_json_path, new_json_path);
        movefile(old_nii_path, new_nii_path);

        fprintf(['      > Renamed sbref magnitude file. \n']);

        %% PHASE FILES:

        % Build the new name for the phase file:
        dcm.part = 'phase';
        cfg_ = generate_bids_filename(cfg,dcm);

        % Define paths to the old files:
        old_json_path = fullfile(cfg.out_folder,cfg.file_name + "_ph.json");
        old_nii_path = fullfile(cfg.out_folder,cfg.file_name + "_ph" + ext);

        % Define paths to the renamed files:
        new_json_path = fullfile(cfg.out_folder, cfg_.file_name + ".json");
        new_nii_path = fullfile(cfg.out_folder, cfg_.file_name + ext);

        % Rename the files:
        movefile(old_json_path, new_json_path);
        movefile(old_nii_path, new_nii_path);

        fprintf(['      > Renamed sbref phase file. \n']);

        %% Update file_names in cfg:
        dcm.part = 'mag'; cfg = generate_bids_filename(cfg,dcm);
        dcm.part = 'phase'; cfg_ = generate_bids_filename(cfg,dcm);
        cfg.file_name_phase_sbref = cfg_.file_name;
    end
end
