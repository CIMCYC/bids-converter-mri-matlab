function updateB0FieldJSON(cfg, dcm)

jsonPaths = {};
fieldName = '';
fieldValue = '';

% Case 1: func or dwi data with an associated fmap identifier. We add the
% B0FieldSource field pointing to the corresponding fmap.
if any(strcmp(dcm.dataType, {'func', 'dwi'})) && isfield(dcm, 'fmapid')
    jsonFiles = dir(fullfile(cfg.outFolder, cfg.fileName + "*.json"));
    for k = 1 : length(jsonFiles)
        jsonPaths{end+1} = fullfile(jsonFiles(k).folder, jsonFiles(k).name); %#ok<AGROW>
    end
    fieldName = 'B0FieldSource';
    fieldValue = dcm.fmapid;

% Case 2: fmap data with an identifier. We add the B0FieldIdentifier field
% to the phasediff JSON sidecar.
elseif strcmp(dcm.dataType, 'fmap') && isfield(dcm, 'identifier')
    phasediffJson = fullfile(cfg.outFolder, cfg.fileName + "_phasediff.json");
    if exist(phasediffJson, 'file')
        jsonPaths{end+1} = phasediffJson;
    end
    fieldName = 'B0FieldIdentifier';
    fieldValue = dcm.identifier;
end

if isempty(jsonPaths) || isempty(fieldName)
    return;
end

for k = 1 : length(jsonPaths)
    jsonPath = jsonPaths{k};
    if ~exist(jsonPath, 'file')
        continue;
    end

    data = jsondecode(fileread(jsonPath));

    % Update JSON
    data.(fieldName) = fieldValue;

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
