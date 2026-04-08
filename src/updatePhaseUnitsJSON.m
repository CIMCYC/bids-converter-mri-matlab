function updatePhaseUnitsJSON(cfg,dcm)

jsonPath = '';

% Caso 1: carpeta marcada explícitamente como fase (dcm.part = 'phase').
if isfield(dcm, 'part') && strcmp(dcm.part, 'phase')
    jsonFiles = dir(fullfile(cfg.outFolder, cfg.fileName + "*.json"));
    if ~isempty(jsonFiles)
        jsonPath = fullfile(jsonFiles(1).folder, jsonFiles(1).name);
    end

% Caso 2: SBRef que además contiene el volumen de fase. dcm2niix añade el
% sufijo _ph al archivo de fase, así que comprobamos su existencia igual
% que se hace en renameBIDSConvertedFiles.m para los SBRef.
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
