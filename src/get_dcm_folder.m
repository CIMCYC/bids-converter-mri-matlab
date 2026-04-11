function cfg = get_dcm_folder(cfg)
% Important: Here we need one or more folders, not their contents. If
% dcm.folder is a folder, applying dir() to it would list the files
% inside it, which is not what we want.

% Make sure there is an asterisk at the end so that we can search for
% matches:
if ~endsWith(cfg.dcm_folder, '*')
    cfg.dcm_folder = [cfg.dcm_folder '*'];
end

% Select the directories and remove '.' and '..' if they appear

items = dir(cfg.dcm_folder);
dcm_folders = items([items.isdir]);
dcm_folders = dcm_folders(~ismember({dcm_folders.name}, {'.','..'}));

%% Several dcm folders found:
% If there are several matches, sort them and keep the first one.
if length(dcm_folders) > 1

    % Sort by name:
    [~, idx] = sort({dcm_folders.name});
    dcm_folders = dcm_folders(idx);

    % Keep only the first one:
    dcm_folders = dcm_folders(1);

    % Warning
    fprintf('   - <strong>Warning:</strong> Multiple folders matched. ');
    fprintf('Using the first one after sorting: \n');
end

%% No dcm folder found:
% It may occur that for a specific subject and session there is no
% associated raw data folder. This is quite common and it is not advisable
% to stop the program execution because of it; it is preferable to continue
% without performing the conversion. In this case, we leave the field empty
% to skip the conversion.

if isempty(dcm_folders)
    % Warning
    fprintf('   - <strong>Warning:</strong> No DCM folders found.\n');
    cfg.dcm_folder = '';
else
    cfg.dcm_folder = fullfile(dcm_folders.folder,dcm_folders.name);
end
end
