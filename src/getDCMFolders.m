function dcmFolders = getDCMFolders(cfg)
% Importante: Aquí necesitamos una/varias carpetas, no su contenido. Si en
% dcm.folder tenemos una carpeta, al aplicarle el dir() estaremos listando
% los archivos de su interior y eso no es lo que queremos.

% Nos aseguramos de que haya un asterisco al final para buscar 
% coincidencias:
if ~endsWith(cfg.dicomFolder, '*')
    cfg.dicomFolder = [cfg.dicomFolder '*'];
end

% Seleccionamos los directorios
allItems = dir(cfg.dicomFolder);
dcmFolders = allItems([allItems.isdir]);

% Eliminamos '.' y '..' si aparecen
dcmFolders = dcmFolders(~ismember({dcmFolders.name}, {'.','..'}));

% Si hay varias coincidencias, ordenamos y nos quedamos con la primera
if length(dcmFolders) > 1
    
    % Ordenar por nombre
    [~, idx] = sort({dcmFolders.name});
    dcmFolders = dcmFolders(idx);
    
    % Quedarse solo con la primera
    dcmFolders = dcmFolders(1);

    % Aviso
    fprintf('   - <strong>Warning:</strong> Multiple folders matched. ');
    fprintf('Using the first one after sorting: \n');
    
end

end