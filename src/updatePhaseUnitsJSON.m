function updatePhaseUnitsJSON(cfg,dcm)

jsonPath = '';

% Case 1: folder explicitly marked as phase (dcm.part = 'phase').
if isfield(dcm, 'part') && strcmp(dcm.part, 'phase')
    jsonFiles = dir(fullfile(cfg.outFolder, cfg.fileName + "*.json"));
    if ~isempty(jsonFiles)
        jsonPath = fullfile(jsonFiles(1).folder, jsonFiles(1).name);
    end

% Case 2: SBRef that also contains the phase volume. dcm2niix appends the
% _ph suffix to the phase file, so we check for its existence in the same
% way it is done in renameBIDSConvertedFiles.m for SBRef data.
elseif isfield(dcm, 'modality') && strcmp(dcm.modality, 'sbref')
    switch cfg.dataFormat
        case 'y', ext = ".nii.gz";
        case 'n', ext = ".nii";
        otherwise, ext = "";
    end
    phaseNii = fullfile(cfg.outFolder, cfg.fileName + "_ph" + ext);
    if exist(phaseNii, "file")
        jsonPath = fullfile(cfg.outFolder, cfg.fileName + "_ph.json");
    end
end

if isempty(jsonPath) || ~exist(jsonPath, 'file')
    return;
end

data = jsondecode(fileread(jsonPath));

% Update JSON
data.Units = 'arbitrary';

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
