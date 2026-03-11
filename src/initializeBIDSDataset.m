function initializeBIDSDataset(cfg, datasetDescription)

fprintf('\n<strong>Initializing BIDS dataset: </strong> \n');

% Creamos la carpeta de salida si no existe:
if ~exist(cfg.outputDirectory, 'dir')
    mkdir(cfg.outputDirectory);
end

%% Generate Dataset Description file

jsonFile = fullfile(cfg.outputDirectory, 'dataset_description.json');

if cfg.generateDatasetDescriptionFile && ~exist(jsonFile, 'file')
    if verLessThan('matlab','9.10')
        data = jsonencode(datasetDescription);
    else
        data = jsonencode(datasetDescription,'PrettyPrint',true);
    end

    fid = fopen([cfg.outputDirectory filesep 'dataset_description.json'], 'w');
    if fid == -1, error('Cannot create JSON file'); end
    fwrite(fid, data, 'char');
    fclose(fid);

    fprintf('  - Dataset description file > <strong>OK</strong> \n');

end

%% Import LICENSE file:
licenseOut = fullfile(cfg.outputDirectory, 'LICENSE');

if cfg.generateLicenseFile && ~exist(licenseOut, 'file')
    if ~isempty(datasetDescription.License)
        file = ['templates/licenses/' datasetDescription.License];
        copyfile(file, [cfg.outputDirectory filesep 'LICENSE']);
        fprintf('  - License file > <strong>OK</strong> \n');
    end
end

%% Import README file:

readmeOut = fullfile(cfg.outputDirectory, 'README');

if cfg.generateREADMEFile && ~exist(readmeOut, 'file')
    file = 'templates/README';
    copyfile(file, [cfg.outputDirectory filesep 'README']);
    fprintf('  - README file (empty) > <strong>OK</strong> \n');
end

%% Generate initial CHANGES file:

changesOut = fullfile(cfg.outputDirectory, 'CHANGES');

if cfg.generateChangesFile && ~exist(changesOut, 'file')
    changesLog = [date ' - Project creation.'];
    fid = fopen([cfg.outputDirectory filesep 'CHANGES'], 'w');
    if fid == -1, error('Cannot create CHANGES file'); end
    fwrite(fid, changesLog, 'char');
    fclose(fid);
    fprintf('  - CHANGES file (empty) > <strong>OK</strong> \n');
end

%% Import .bidsignore file:

bidsIgnoreOut = fullfile(cfg.outputDirectory, '.bidsignore');

if cfg.generateBIDSIgnoreFile && ~exist(bidsIgnoreOut, 'file')
    file = 'templates/.bidsignore';
    copyfile(file, [cfg.outputDirectory filesep '.bidsignore']);
    fprintf('  - .bidsignore file > <strong>OK</strong> \n');
end


end

