function dcmFolders = getDCMFolders(cfg)
% Importante: Aquí necesitamos una/varias carpetas, no su contenido. Si en
% dcm.folder tenemos una carpeta, al aplicarle el dir() estaremos listando
% los archivos de su interior y eso no es lo que queremos.

% Nos aseguramos de que haya un asterisco al final para buscar
% coincidencias:

if ~endsWith(cfg.dicomFolder, '*')
    cfg.dicomFolder = [cfg.dicomFolder '*'];
end

% Seleccionamos los directorios:
allItems = dir(cfg.dicomFolder);
dcmFolders = allItems([allItems.isdir]);

%% Posible error:
% Mostramos un warning si hay varias carpetas que pasen el filtro del
% nombre, el comportamiento ideal es que en cada celda del dcm tengamos
% solo una ruta a la carpeta.

if length(dcmFolders) > 1
    warning('Possible error: More than one folder asociated to dcm.');
end
end

