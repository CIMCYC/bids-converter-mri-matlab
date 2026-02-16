function updateALSJSON(cfg,dcm)
if strcmp(dcm.dataType, 'perf') && strcmp(dcm.modality, 'asl')
    jsonFiles = dir(fullfile(cfg.outFolder, cfg.fileName + "*.json"));
    if ~isempty(jsonFiles)
        jsonPath = fullfile(jsonFiles(1).folder, jsonFiles(1).name);
        data = jsondecode(fileread(jsonPath));

        % Update JSON
        data.M0Type = dcm.M0Type;
        data.PostLabelingDelay = dcm.PostLabelingDelay;
        data.BackgroundSuppression = dcm.BackgroundSuppression;
        data.TotalAcquiredPairs = dcm.TotalAcquiredPairs;

        % Encode JSON
        if verLessThan('matlab','9.10')
            jsonText = jsonencode(data);
        else
            jsonText = jsonencode(data, 'PrettyPrint', true);
        end

        % Save updated JSON
        fid = fopen(jsonPath, 'w');
        assert(fid ~= -1, 'Cannot create JSON file');
        fwrite(fid, jsonText, 'char');
        fclose(fid);
    end
end
end

