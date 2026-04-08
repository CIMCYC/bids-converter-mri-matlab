function dcmFolders = getDCMFolders(cfg)
% Important: Here we need one or more folders, not their contents. If
% dcm.folder is a folder, applying dir() to it would list the files
% inside it, which is not what we want.

% Make sure there is an asterisk at the end so that we can search for
% matches:
if ~endsWith(cfg.dicomFolder, '*')
    cfg.dicomFolder = [cfg.dicomFolder '*'];
end

% Select the directories
allItems = dir(cfg.dicomFolder);
dcmFolders = allItems([allItems.isdir]);

% Remove '.' and '..' if they appear
dcmFolders = dcmFolders(~ismember({dcmFolders.name}, {'.','..'}));

% If there are several matches, sort them and keep the first one
if length(dcmFolders) > 1

    % Sort by name
    [~, idx] = sort({dcmFolders.name});
    dcmFolders = dcmFolders(idx);

    % Keep only the first one
    dcmFolders = dcmFolders(1);

    % Warning
    fprintf('   - <strong>Warning:</strong> Multiple folders matched. ');
    fprintf('Using the first one after sorting: \n');

end

end
