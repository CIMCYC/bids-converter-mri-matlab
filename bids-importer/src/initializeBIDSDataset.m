function initializeBIDSDataset(cfg, datasetDescription)

% Creamos la carpeta de salida si no existe:
if ~exist(cfg.outputDirectory, 'dir')


    mkdir(cfg.outputDirectory);

    %% Generate Dataset Description file

    if cfg.generateDatasetDescriptionFile
        if verLessThan('matlab','9.10')
            data = jsonencode(datasetDescription);
        else
            data = jsonencode(datasetDescription,'PrettyPrint',true);
        end

        fid = fopen([cfg.outputDirectory filesep 'dataset_description.json'], 'w');
        if fid == -1, error('Cannot create JSON file'); end
        fwrite(fid, data, 'char');
        fclose(fid);
    end

    %% Import LICENSE file:

    if cfg.generateLicenseFile
        if ~isempty(datasetDescription.License)
            file = ['templates/licenses/' datasetDescription.License];
            copyfile(file, [cfg.outputDirectory filesep 'LICENSE']);
            disp(['> License file ' ...
                datasetDescription.License ...
                ' has been added to the project folder.'])
        end
    end

    %% Import README file:

    if cfg.generateREADMEFile
        file = 'templates/README';
        copyfile(file, [cfg.outputDirectory filesep 'README']);
        disp('> Warning: Please, remember to edit the generated README file.')
    end

    %% Generate initial CHANGES file:

    if cfg.generateChangesFile
        changesLog = [date ' - Project creation.'];
        fid = fopen([cfg.outputDirectory filesep 'CHANGES'], 'w');
        if fid == -1, error('Cannot create CHANGES file'); end
        fwrite(fid, changesLog, 'char');
        fclose(fid);
        disp('> Warning: Please, remember to edit the generated CHANGES file.')
    end

end

end

