function renameBIDSConvertedFiles(cfg, dcm)

switch cfg.dataFormat
    case 'y', ext = ".nii.gz";
    case 'n', ext = ".nii";
    otherwise, ext = "";
end


%% Rename fmap files:
if strcmp(dcm.dataType, 'fmap')

    jsonFiles = dir(fullfile(cfg.outFolder, cfg.fileName + "*.json"));

    for file = jsonFiles'
        % Determine new file name based on suffix
        if endsWith(file.name, '_ph.json')
            newBase = cfg.fileName + "_phasediff";
        elseif endsWith(file.name, '_e1.json')
            newBase = cfg.fileName + "_magnitude1";
        elseif endsWith(file.name, '_e2.json')
            newBase = cfg.fileName + "_magnitude2";
        else
            continue; % Skip if suffix is unknown
        end

        % Eliminamos los caracteres duplicados:
        newBase = removeDuplicateChar(newBase, '_');

        % Definimos los path a los archivos antiguos:
        oldJsonPath = fullfile(file.folder, file.name);
        oldNiiPath = oldJsonPath(1:end-5) + ext;

        % Definimos las rutas a los archivos renombrados:
        newJsonPath = fullfile(file.folder, newBase + ".json");
        newNiiPath = fullfile(file.folder, newBase + ext);

        % Renombramos los archivos:
        movefile(oldJsonPath, newJsonPath);
        movefile(oldNiiPath, newNiiPath);
    end
end

%% Renombramos las series de fase:
% Cuando estamos convirtiendo la fase de la señal y no la magnitud, el
% conversor dcm2niix le añade siempre el prefijo _ph al archivo convertido.
% Esto no es compatible con BIDS, ya que la fase se codifica en la entidad
% part-pha del nombre.

if isfield(dcm, 'part') && strcmp(dcm.part, 'phase')

    % Definimos los path a los archivos antiguos:
    oldJsonPath = fullfile(cfg.outFolder, cfg.fileName + "_ph.json");
    oldNiiPath = fullfile(cfg.outFolder, cfg.fileName + "_ph" + ext);

    % Definimos las rutas a los archivos renombrados:
    newJsonPath = fullfile(cfg.outFolder, cfg.fileName + ".json");
    newNiiPath = fullfile(cfg.outFolder, cfg.fileName + ext);

    % Renombramos los archivos:
    movefile(oldJsonPath, newJsonPath);
    movefile(oldNiiPath, newNiiPath);

end

%% Renombramos las imágenes SBRef:
% En caso de almacenar la fase, los carpeta SBRef contiene dos volúmenes, 
% uno para la magnitud y otro para la fase. El conversor dcm2niix en caso
% de encontrar las dos imágenes las convierte y añade el sufijo _ph al
% archivo de fase.

if strcmp(dcm.modality, 'sbref')

    % Buscamos el archivo con el sufijo _ph. En caso de encontrarlo podemos
    % asumir que se está almacenando la fase, en caso de no encontrarlo
    % asuminos que no, por lo que no tendríamos que hacer nada:

    phaseFile = fullfile(cfg.outFolder, cfg.fileName + "_ph" + ext);
    
    if exist(phaseFile, "file")

        % ARCHIVOS DE MAGNITUD:

        % Generamos el nuevo nombre del archivo de magnitud:
        dcm.part = 'mag';
        cfg_ = generateBIDSFileName(cfg,dcm);
        
        % Definimos los path a los archivos antiguos:
        oldJsonPath = fullfile(cfg.outFolder, cfg.fileName + ".json");
        oldNiiPath = fullfile(cfg.outFolder, cfg.fileName  + ext);

        % Definimos las rutas a los archivos renombrados:
        newJsonPath = fullfile(cfg.outFolder, cfg_.fileName + ".json");
        newNiiPath = fullfile(cfg.outFolder, cfg_.fileName + ext);
        
        % Renombramos los archivos:
        movefile(oldJsonPath, newJsonPath);
        movefile(oldNiiPath, newNiiPath);

        % ARCHIVOS DE FASE:

        % Generamos el nuevo nombre del archivo de fase:
        dcm.part = 'phase';
        cfg_ = generateBIDSFileName(cfg,dcm);

        % Definimos los path a los archivos antiguos:
        oldJsonPath = fullfile(cfg.outFolder, cfg.fileName + "_ph.json");
        oldNiiPath = fullfile(cfg.outFolder, cfg.fileName + "_ph" + ext);

        % Definimos las rutas a los archivos renombrados:
        newJsonPath = fullfile(cfg.outFolder, cfg_.fileName + ".json");
        newNiiPath = fullfile(cfg.outFolder, cfg_.fileName + ext);

        % Renombramos los archivos:
        movefile(oldJsonPath, newJsonPath);
        movefile(oldNiiPath, newNiiPath);
    end
end