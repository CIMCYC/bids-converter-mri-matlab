function command = generateCommand(cfg,dcm)
if isfield(dcm, 'derivatives') && 0
    command{1} = sprintf('dcm2niix -f "%s" -z "%s" -ba "%s" -o "%s" "%s"', cfg.fileName, cfg.dataFormat, cfg.anonymization, cfg.derivativeFolder, cfg.inFolder);
else
    if strcmp(dcm.dataType,'mrs')
        
        % Esto es necesario porque en sistemas linux no funciona el comando
        % "spec2nii auto" pasandole como argumento un directorio, hay que
        % pasarle el archivo .dcm directamente. Si en la carpeta existiesen
        % más archivos .dcm habría que implementar un bucle generando
        % comandos para cada archivo. Suponemos por ahora que cada carpeta
        % solo tiene un .dcm de espectroscopia que convertir. 
        
        listOfFiles = dir(fullfile(cfg.inFolder, '*.dcm'));
        if ~isempty(listOfFiles)
            cfg.inFolder = fullfile(listOfFiles(1).folder, listOfFiles(1).name);
        end

        % La anonimización de datos en spec2nii se hace en distintos
        % pasos, primero se convierte el DICOM original a NIFTI, luego
        % se eliminan los campos que queramos anonimizar y finalmente
        % extraemos el JSON con los metadatos aninimizados.
        if strcmp(cfg.anonymization,'y')
            % Convertimos
            command{1} = sprintf('spec2nii auto "%s" -o "%s" -f "%s"', cfg.inFolder, cfg.outFolder, cfg.fileName);
            
            % Anonimizamos
            command{2} = sprintf('spec2nii anon "%s" -r PatientName -r PatientWeight -r PatientDoB -r PatientSex -v -o "%s" -f "%s"', fullfile(cfg.outFolder,  cfg.fileName), cfg.outFolder, cfg.fileName);

            % Extraemos el JSON:
            command{3} = sprintf('spec2nii extract "%s" ', fullfile(cfg.outFolder,  cfg.fileName));

        else
            command{1} = sprintf('spec2nii auto "%s" -o "%s" -f "%s" -j', cfg.inFolder, cfg.outFolder, cfg.fileName);
        end
    else
        command{1} = sprintf('dcm2niix -f "%s" -z "%s" -ba "%s" -o "%s" "%s"', cfg.fileName, cfg.dataFormat, cfg.anonymization, cfg.outFolder, cfg.inFolder);
    end
end
end

