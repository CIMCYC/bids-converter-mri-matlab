function subjects = get_subjects_list(cfg)
% DISCOVER_BIDS_SUBJECTS
% Searches for participant subfolders inside a root folder.
%
% Each subfolder:
%   - must be a directory
%   - cannot be '.' or '..'
%   - the name will be used as the subject ID
%
% OUTPUT:
%   subjects.root      Root directory that was scanned (cfg.rawDICOM).
%   subjects.ids       Cell array of BIDS subject IDs, e.g.{'sub-001',...}.
%   subjects.paths     Cell array kept for backwards compatibility. Each
%                      entry points to the first (oldest) session path of
%                      the corresponding subject, so legacy callers that
%                      still read subjects.paths{i} keep working.
%   subjects.n         Number of valid subjects (those with at least one
%                      session subfolder).
%   subjects.sessions  Cell array parallel to ids/paths. Each cell holds a
%                      1xM struct array describing the sessions detected
%                      for that subject, with fields:
%                        .id       BIDS session id, e.g. 'ses-01'
%                        .name     Original folder name on disk
%                        .path     Full path to the session folder
%                        .datenum  Modification time used for ordering

%% Validate root folder:
% Check that the provided folder exists and is actually a folder.

cfg.root_folder = char(cfg.root_folder);

if ~isfolder(cfg.root_folder)
    error('The provided path does not exist or is not a folder:\n%s', ...
        cfg.root_folder)
end

%% Conversion mode:
% If we are in single subject mode, the folders_list will be the 
% root_folder. Otherwise, we must scan the directory and extract the 
% subject folders.

if strcmp(cfg.conversion_mode, 'single_subject')

    [root, name, ~] = fileparts(cfg.root_folder);
    
    % Update the root_folder:
    cfg.root_folder = root;

    % Generate the struct:
    folders_list = struct();
    folders_list.name = name;
    folders_list.folder = root;
    folders_list.date = ''; 
    folders_list.bytes = NaN;
    folders_list.isdir = true;
    folders_list.datenum = NaN;

else
    %% List the contents:
    % List the full contents of the folder. We also remove the very common
    % '.' and '..' entries. Additionally, we check that the folder is not
    % empty.

    folders_list = dir(cfg.root_folder);
    folders_list = folders_list(~ismember({folders_list.name}, {'.','..'}));

    if isempty(folders_list)
        error('The folder is empty: %s', cfg.root_folder)
    end

    %% Keep only directories:
    % Keep only the directories, removing any files contained in the root
    % folder that do not correspond to participant folders.

    is_dir = [folders_list.isdir];
    folders_list = folders_list(is_dir);

    if isempty(folders_list)
        error('No participant subfolders were found in: %s', cfg.root_folder)
    end
end

%% Generate subjects IDs and paths:
% The name of each folder will be used as the subject ID for the data
% transformed to BIDS. For this reason, we must check that the
% characters are alphanumeric (we must avoid the use of - or _).

% Initialization:
subject_ids = {};
subject_paths = {};

% Iterate over subjects folders:
for i = 1:numel(folders_list)

    subject_name = folders_list(i).name;

    % Skip hidden folders such as .DS_Store or .git
    if startsWith(subject_name, '.')
        continue
    end

    % Build the full path to the participant folder.
    subject_path = fullfile(cfg.root_folder, subject_name);

    % Extra robust check
    if ~isfolder(subject_path)
        continue
    end

    % Validate BIDS-compatible name:
    validate_subject_name(subject_name)

    % Store the participant's ID and foder:
    subject_ids{end+1,1} = ['sub-' subject_name];               %#ok<AGROW>
    subject_paths{end+1,1} = subject_path;                      %#ok<AGROW>

end

%% Sessions:
% Discover session subfolders inside the participant directory. Every
% direct subfolder of the subject is treated as a session. The session
% ID is derived from the folder name, sanitized to remove any
% non-alphanumeric characters for BIDS compatibility.

% Initialization:
subject_sessions = {};

% Iterate over subjects folders:
for i = 1 : numel(subject_paths)

    % List session folders for a specific subject:
    session_folders = list_session_folders(subject_paths{i});

    % Skip if the session folder list is empty:
    if isempty(session_folders)
        warning('getSubjectsList:NoSessions', ...
            'Subject "%s" has no session subfolders. Skipping.', ...
            subject_name)
        continue
    end

    % Build the session cell array for this subject.
    sessions_for_subject = {};

    for j = 1:numel(session_folders)
        session.id = ['ses-' regexprep(session_folders(j).name, '[^a-zA-Z0-9]', '')];
        session.name = session_folders(j).name;
        session.path = fullfile(subject_paths{i}, session_folders(j).name);
        session.datenum = session_folders(j).datenum;

        sessions_for_subject{j,1} = session;                    %#ok<AGROW>
    end

    subject_sessions{end+1,1} = sessions_for_subject;           %#ok<AGROW>
end


%% Final checks:
% Perform some final checks, such as making sure that there are valid
% paths for the participants and that there are no duplicated names.

if isempty(subject_ids)
    error('No valid participant folders were found.')
end

if numel(unique(subject_ids)) ~= numel(subject_ids)
    error('Duplicated subject IDs found.')
end

%% Build the output structure

subjects = struct();
subjects.root = cfg.root_folder;
subjects.ids = subject_ids;
subjects.paths = subject_paths;
subjects.sessions = subject_sessions;
subjects.n = numel(subject_ids);

end

%% Alphanumeric validation function:
function validate_subject_name(name)
if isempty(regexp(name, '^[a-zA-Z0-9]+$', 'once'))
    error(['Invalid subject name for BIDS:\n' ...
        '  "%s"\n' ...
        'Only alphanumeric characters are allowed.'], name)
end
end

%% Session folder listing helper:
function entries = list_session_folders(subject_path)
%LISTSESSIONFOLDERS  Direct subfolders of subject_path as a dir struct.
% Excludes '.', '..', hidden entries and non-directories. Entries are
% returned in the order provided by the file system. Returns an empty
% typed struct on failure or when no valid candidates remain, so the
% caller can treat "no sessions" uniformly.

empty_out = struct('name', {}, 'folder', {}, 'date', {}, ...
    'bytes', {}, 'isdir', {}, 'datenum', {});

try
    entries = dir(subject_path);
catch
    entries = empty_out;
    return
end

entries = entries(~ismember({entries.name}, {'.','..'}));
if isempty(entries), entries = empty_out; return; end

entries = entries([entries.isdir]);
if isempty(entries), entries = empty_out; return; end

entries = entries(~startsWith({entries.name}, '.'));
if isempty(entries), entries = empty_out; return; end

end
