function renameBIDSConvertedFiles(cfg, dcm)

%% Rename fmap files:
if strcmp(dcm.dataType, 'fmap')
    switch cfg.dataFormat
        case 'y', ext = ".nii.gz";
        case 'n', ext = ".nii";
        otherwise, ext = "";
    end

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

        % Clean up duplicate underscores
        newBase = removeDuplicateChar(newBase, '_');

        % Paths
        oldJsonPath = fullfile(file.folder, file.name);
        newJsonPath = fullfile(file.folder, newBase + ".json");
        oldNiiPath = oldJsonPath(1:end-5) + ext;
        newNiiPath = fullfile(file.folder, newBase + ext);

        % Rename files
        movefile(oldJsonPath, newJsonPath);
        movefile(oldNiiPath, newNiiPath);
    end
end

end