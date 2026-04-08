function cfg = generateOutputDirectories(cfg, dcmFolders)
% Convert to string in case there are whitespaces in the paths:
cfg.inFolder = string([dcmFolders.folder filesep dcmFolders.name]);
cfg.outFolder = string(cfg.outFolder);

% Create the output folder if it does not exist:
if ~exist(cfg.outFolder, 'dir')
    mkdir(cfg.outFolder);
end

% Create the derivatives folder if needed
% if ~exist(cfg.derivativesFolder, 'dir')
%     mkdir(cfg.derivativesFolder);
% end
end

