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

    % if ~exist(cfg.derivativesFolder, 'dir')
    %     mkdir(cfg.derivativesFolder);
    % end

    % Detectar sistema operativo para añadir el path a dcm2niix:
    if ismac
        % Añadir rutas típicas de Homebrew y /usr/local a PATH si no están
        currentPath = getenv('PATH');
        extraPaths = {'/usr/local/bin', '/opt/homebrew/bin'};
        for p = extraPaths
            if ~contains(currentPath, p{1})
                currentPath = [currentPath ':' p{1}];
            end
        end
        setenv('PATH', currentPath);
    end

    % Verificar si dcm2niix es accesible
    [status_check, cmdout_check] = system('which dcm2niix');
    if status_check ~= 0
        warning('dcm2niix no se encuentra en el PATH. cmdout: %s', ...
            cmdout_check);
    end

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