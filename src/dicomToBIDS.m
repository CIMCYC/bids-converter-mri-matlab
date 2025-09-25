function cmdout = dicomToBIDS(cfg, dcm)

dcmFolder = dir(dcm.folder);

for f = 1 : length(dcmFolder)

    % Convetimos en string por si hay espacios en el nombre
    inFolder = string([dcmFolder(f).folder filesep dcmFolder(f).name]);
    cfg.outFolder = string(cfg.outFolder);

    % Creamos la carpeta de salida si no existe:
    if ~exist(cfg.outFolder, 'dir')
        mkdir(cfg.outFolder);
    end

    % if ~exist(cfg.derivativesFolder, 'dir')
    %     mkdir(cfg.derivativesFolder);
    % end

    % Construcción del comando:
    if isfield(dcm, 'derivatives') && 0
        command = sprintf('dcm2niix -f "%s" -z "%s" -o "%s" "%s"', ...
            cfg.fileName, cfg.dataFormat, cfg.derivativeFolder, inFolder);
    else
        command = sprintf('dcm2niix -f "%s" -z "%s" -o "%s" "%s"', ...
            cfg.fileName, cfg.dataFormat, cfg.outFolder, inFolder);
    end

    disp('Converting DICOM data from: ')
    disp(inFolder)

    % Ejecutar el comando
    [status, cmdout] = system(command);

    if status == 0
        disp('> Done!');
    else
        warning('Conversion Error.');
    end

    %% Update taskName in sidecar JSON:
    updateTaskNameJSON(cfg, dcm);

    %% Rename BIDS converted files:
    renameBIDSConvertedFiles(cfg,dcm);

end

end