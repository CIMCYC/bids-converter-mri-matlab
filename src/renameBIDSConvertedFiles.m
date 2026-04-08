function renameBIDSConvertedFiles(cfg, dcm)

switch cfg.dataFormat
    case 'y', ext = ".nii.gz";
    case 'n', ext = ".nii";
    otherwise, ext = "";
end


%% Rename fmap files:
if strcmp(dcm.dataType, 'fmap')

    jsonFiles = dir(fullfile(cfg.outFolder, cfg.fileName + "*.json"));

    for file = jsonFiles'
        % Determine new file name based on suffix
        if endsWith(file.name, '_ph.json')
            newBase = cfg.fileName + "_phasediff";
        elseif endsWith(file.name, '_e1.json')
            newBase = cfg.fileName + "_magnitude1";
        elseif endsWith(file.name, '_e2.json')
            newBase = cfg.fileName + "_magnitude2";
        else
            continue; % Skip if suffix is unknown
        end

        % Remove duplicated characters:
        newBase = removeDuplicateChar(newBase, '_');

        % Define paths to the old files:
        oldJsonPath = fullfile(file.folder, file.name);
        oldNiiPath = oldJsonPath(1:end-5) + ext;

        % Define paths to the renamed files:
        newJsonPath = fullfile(file.folder, newBase + ".json");
        newNiiPath = fullfile(file.folder, newBase + ext);

        % Rename the files:
        movefile(oldJsonPath, newJsonPath);
        movefile(oldNiiPath, newNiiPath);
    end
end

%% Rename phase series:
% When converting the phase of the signal instead of the magnitude,
% dcm2niix always adds the _ph prefix to the converted file. This is not
% BIDS compatible, since the phase is encoded in the part-pha entity of
% the filename.

if isfield(dcm, 'part') && strcmp(dcm.part, 'phase')

    % Define paths to the old files:
    oldJsonPath = fullfile(cfg.outFolder, cfg.fileName + "_ph.json");
    oldNiiPath = fullfile(cfg.outFolder, cfg.fileName + "_ph" + ext);

    % Define paths to the renamed files:
    newJsonPath = fullfile(cfg.outFolder, cfg.fileName + ".json");
    newNiiPath = fullfile(cfg.outFolder, cfg.fileName + ext);

    % Rename the files:
    movefile(oldJsonPath, newJsonPath);
    movefile(oldNiiPath, newNiiPath);

end

%% Rename SBRef images:
% When the phase is also stored, the SBRef folder contains two volumes,
% one for the magnitude and one for the phase. If dcm2niix finds both
% images, it converts them and appends the _ph suffix to the phase file.

if strcmp(dcm.modality, 'sbref')

    % Look for the file with the _ph suffix. If we find it we can assume
    % that the phase is being stored; otherwise, we assume it is not and
    % we do not need to do anything:

    phaseFile = fullfile(cfg.outFolder, cfg.fileName + "_ph" + ext);

    if exist(phaseFile, "file")

        % MAGNITUDE FILES:

        % Build the new name for the magnitude file:
        dcm.part = 'mag';
        cfg_ = generateBIDSFileName(cfg,dcm);

        % Define paths to the old files:
        oldJsonPath = fullfile(cfg.outFolder, cfg.fileName + ".json");
        oldNiiPath = fullfile(cfg.outFolder, cfg.fileName  + ext);

        % Define paths to the renamed files:
        newJsonPath = fullfile(cfg.outFolder, cfg_.fileName + ".json");
        newNiiPath = fullfile(cfg.outFolder, cfg_.fileName + ext);

        % Rename the files:
        movefile(oldJsonPath, newJsonPath);
        movefile(oldNiiPath, newNiiPath);

        % PHASE FILES:

        % Build the new name for the phase file:
        dcm.part = 'phase';
        cfg_ = generateBIDSFileName(cfg,dcm);

        % Define paths to the old files:
        oldJsonPath = fullfile(cfg.outFolder, cfg.fileName + "_ph.json");
        oldNiiPath = fullfile(cfg.outFolder, cfg.fileName + "_ph" + ext);

        % Define paths to the renamed files:
        newJsonPath = fullfile(cfg.outFolder, cfg_.fileName + ".json");
        newNiiPath = fullfile(cfg.outFolder, cfg_.fileName + ext);

        % Rename the files:
        movefile(oldJsonPath, newJsonPath);
        movefile(oldNiiPath, newNiiPath);
    end
end
