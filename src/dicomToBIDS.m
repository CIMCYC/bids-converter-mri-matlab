function cmdout = dicomToBIDS(cfg, dcm)

% Importante: Aquí necesitamos una/varias carpetas, no su contenido. Si en
% dcm.folder tenemos una carpeta, al aplicarle el dir() estaremos listando
% los archivos de su interior y eso no es lo que queremos. 

% Nos aseguramos de que haya un asterisco al final para buscar 
% coincidencias:

if ~endsWith(dcm.folder, '*')
    dcm.folder = [dcm.folder '*'];
end

allItems = dir(dcm.folder);
dcmFolders = allItems([allItems.isdir]);

% Mostramos un warning si hay varias carpetas que pasen el filtro del
% nombre, el comportamiento ideal es que en cada celda del dcm tengamos
% solo una ruta a la carpeta.

if length(dcmFolders) > 1
    warning('Possible error: More than one folder asociated to dcm.');
end

for f = 1 : length(dcmFolders)

    % Convetimos en string por si hay espacios en el nombre
    inFolder = string([dcmFolders(f).folder filesep dcmFolders(f).name]);
    cfg.outFolder = string(cfg.outFolder);

    % Creamos la carpeta de salida si no existe:
    if ~exist(cfg.outFolder, 'dir')
        mkdir(cfg.outFolder);
    end

    % Creamos la carpeta de derivatives si fuese necesario:
    % if ~exist(cfg.derivativesFolder, 'dir')
    %     mkdir(cfg.derivativesFolder);
    % end

    %% Check dcm-nii converters:
    % Comprobamos que los conversores de datos son accesibles desde el
    % comando 
    checkDataConverters();

    %% Construcción del comando:
    if isfield(dcm, 'derivatives') && 0
        command = sprintf('dcm2niix -f "%s" -z "%s" -o "%s" "%s"', ...
            cfg.fileName, cfg.dataFormat, cfg.derivativeFolder, inFolder);
    else
        if strcmp(dcm.dataType,'mrs') 
            command = sprintf('spec2nii auto "%s" -o "%s" -f "%s" -j', ...
                inFolder, cfg.outFolder, cfg.fileName);
        else
            command = sprintf('dcm2niix -f "%s" -z "%s" -o "%s" "%s"', ...
                cfg.fileName, cfg.dataFormat, cfg.outFolder, inFolder);
        end
    end

    disp('Converting DICOM data from: ')
    disp(inFolder)

    % Ejecutar el comando
    [status, cmdout] = system(command);

    % Mostramos el resultado:
    if status ~= 0
        fprintf('Error ejecutando dcm2niix (status %d):\n%s\n', ...
            status, cmdout);
    else
        disp('> Conversión completada correctamente.');
    end

    %% Update taskName in sidecar JSON:
    updateTaskNameJSON(cfg, dcm);

    %% Rename BIDS converted files:
    renameBIDSConvertedFiles(cfg,dcm);

end

end