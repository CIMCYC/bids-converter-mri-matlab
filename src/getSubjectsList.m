function subjects = getSubjectsList(cfg)
% DISCOVER_BIDS_SUBJECTS
% Searches for participant subfolders inside a root folder.
%
% Each subfolder:
%   - must be a directory
%   - cannot be '.' or '..'
%   - the name will be used as the subject ID
%
% OUTPUT:
%   subjects.root
%   subjects.ids
%   subjects.paths
%   subjects.n

%% Validate root folder:
% Check that the provided folder exists and is actually a folder.

root_dir = cfg.rawDICOM;

if ~isfolder(root_dir)
    error('The provided path does not exist or is not a folder:\n%s', root_dir)
end

root_dir = char(root_dir);

%% List the contents:
% List the full contents of the folder. We also remove the very common
% '.' and '..' entries. Additionally, we check that the folder is not
% empty.

subjectsList = dir(root_dir);
subjectsList = subjectsList(~ismember({subjectsList.name}, {'.','..'}));

if isempty(subjectsList)
    error('The folder is empty: %s', root_dir)
end

%% Keep only directories:
% Keep only the directories, removing any files contained in the root
% folder that do not correspond to participant folders.

is_dir = [subjectsList.isdir];
subjectsList = subjectsList(is_dir);

if isempty(subjectsList)
    error('No participant subfolders were found in: %s', root_dir)
end

%% Check that the subject names are valid.
% The name of each folder will be used as the subject ID for the data
% transformed to BIDS. For this reason, we must check that the
% characters are alphanumeric (we must avoid the use of - or _).

subjectIDs = {};
subjectPaths = {};

for i = 1:numel(subjectsList)

    subjectName = subjectsList(i).name;

    % Skip hidden folders such as .DS_Store or .git
    if startsWith(subjectName, '.')
        continue
    end

    % Build the full path to the participant folder.
    subjectPath = fullfile(root_dir, subjectName);

    % Extra robust check
    if ~isfolder(subjectPath)
        continue
    end

    % Validate BIDS-compatible name
    validateSubjectName(subjectName)

    % Store the participant's name and path.
    subjectIDs{end+1} = ['sub-' subjectName];
    subjectPaths{end+1} = [subjectPath filesep cfg.ip];

end

%% Final checks:
% Perform some final checks, such as making sure that there are valid
% paths for the participants and that there are no duplicated names.

if isempty(subjectIDs)
    error('No valid participant folders were found.')
end

if numel(unique(subjectIDs)) ~= numel(subjectIDs)
    error('Duplicated subject IDs found.')
end

%% Build the output structure

subjects = struct();
subjects.root = root_dir;
subjects.ids = subjectIDs;
subjects.paths = subjectPaths;
subjects.n = numel(subjectIDs);

end

%% Alphanumeric validation function:
function validateSubjectName(name)
if isempty(regexp(name, '^[a-zA-Z0-9]+$', 'once'))
    error(['Invalid subject name for BIDS:\n' ...
        '  "%s"\n' ...
        'Only alphanumeric characters are allowed.'], name)
end
end
