function cfg = generate_output_directories(cfg)

% Convert to string in case there are whitespaces in the paths:

cfg.dcm_folder = string(cfg.dcm_folder);
cfg.out_folder = string(cfg.out_folder);

% Create the output folder if it does not exist:
if ~exist(cfg.out_folder, 'dir')
    mkdir(cfg.out_folder);
end

% Create the derivatives folder if needed
% if ~exist(cfg.derivativesFolder, 'dir')
%     mkdir(cfg.derivativesFolder);
% end

end

