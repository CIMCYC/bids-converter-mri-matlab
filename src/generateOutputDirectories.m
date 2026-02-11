function cfg = generateOutputDirectories(cfg, dcmFolders)
% Convertimos a string por si existen espacios en blanco en las rutas:
cfg.inFolder = string([dcmFolders.folder filesep dcmFolders.name]);
cfg.outFolder = string(cfg.outFolder);

% Creamos la carpeta de salida si no existe:
if ~exist(cfg.outFolder, 'dir')
    mkdir(cfg.outFolder);
end

% Creamos la carpeta de derivatives si fuese necesario
% if ~exist(cfg.derivativesFolder, 'dir')
%     mkdir(cfg.derivativesFolder);
% end
end

