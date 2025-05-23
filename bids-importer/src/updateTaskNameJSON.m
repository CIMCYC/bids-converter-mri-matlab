function updateTaskNameJSON(cfg,dcm)

%% FUNCTIONAL: TaskName problem in the sidecar JSON file:
if strcmp(dcm.dataType, 'func') && isfield(dcm, 'task')
    jsonFiles = dir(fullfile(cfg.outFolder, cfg.fileName + "*.json"));
    if ~isempty(jsonFiles)
        jsonPath = fullfile(jsonFiles(1).folder, jsonFiles(1).name);
        data = jsondecode(fileread(jsonPath));

        % Update TaskName
        data.TaskName = dcm.task;

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

