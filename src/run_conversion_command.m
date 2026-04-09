function [status, cmdout] = run_conversion_command(cfg,command)

% Show progress:
[~, f] = fileparts(cfg.dcm_folder);
fprintf(['   - DCM Folder: ' char(f) '>']);

% Execute the system calls:
for i = 1 : length(command)
    [status, cmdout] = system(command{i});
end

% Show the result:
if status ~= 0
    fprintf('<strong> ERROR </strong> \n');
    fprintf('(status %d):\n%s\n', status, cmdout);
else
    fprintf('<strong> OK </strong> \n');
end
end

