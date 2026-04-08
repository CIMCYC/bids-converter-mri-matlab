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
%   subjects.root      Root directory that was scanned (cfg.rawDICOM).
%   subjects.ids       Cell array of BIDS subject IDs, e.g. {'sub-001', ...}.
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
subjectSessions = {};

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

    % Discover session subfolders inside the participant directory.
    % Note: cfg.ip is no longer consulted here. Every direct subfolder
    % of the subject is treated as a session, sorted by modification
    % time (oldest first) so that ses-01 is the earliest acquisition.
    entries = listSessionFolders(subjectPath);

    if isempty(entries)
        warning('getSubjectsList:NoSessions', ...
            'Subject "%s" has no session subfolders. Skipping.', ...
            subjectName)
        continue
    end

    % Build the session struct array for this subject.
    sessionsForSubject = repmat(struct( ...
        'id', '', 'name', '', 'path', '', 'datenum', 0), ...
        1, numel(entries));

    for k = 1:numel(entries)
        sessionsForSubject(k).id      = sprintf('ses-%02d', k);
        sessionsForSubject(k).name    = entries(k).name;
        sessionsForSubject(k).path    = fullfile(subjectPath, entries(k).name);
        sessionsForSubject(k).datenum = entries(k).datenum;
    end

    % Store the participant's name, sessions and a backwards compatible
    % path entry pointing at the first (oldest) session, so that
    % callers still reading subjects.paths{i} keep working until the
    % multi-session iteration refactor lands in bidsConverter.m.
    subjectIDs{end+1}      = ['sub-' subjectName]; %#ok<AGROW>
    subjectSessions{end+1} = sessionsForSubject;   %#ok<AGROW>
    subjectPaths{end+1}    = sessionsForSubject(1).path; %#ok<AGROW>

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
subjects.sessions = subjectSessions;
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

%% Session folder listing helper:
function entries = listSessionFolders(subjectPath)
%LISTSESSIONFOLDERS  Direct subfolders of subjectPath as a sorted dir struct.
%   Excludes '.', '..', hidden entries and non-directories. Entries are
%   sorted by modification time ascending (oldest first), with a stable
%   alphabetical tie-break so the order is deterministic across operating
%   systems. Returns an empty typed struct on failure or when no valid
%   candidates remain, so the caller can treat "no sessions" uniformly.
%
%   Note: the sort relies on the file system modification time (mtime).
%   If session folders were copied from another machine or restored from
%   a backup, mtime may not reflect the real acquisition order.

emptyOut = struct('name', {}, 'folder', {}, 'date', {}, ...
    'bytes', {}, 'isdir', {}, 'datenum', {});

try
    entries = dir(subjectPath);
catch
    entries = emptyOut;
    return
end

entries = entries(~ismember({entries.name}, {'.','..'}));
if isempty(entries), entries = emptyOut; return; end

entries = entries([entries.isdir]);
if isempty(entries), entries = emptyOut; return; end

entries = entries(~startsWith({entries.name}, '.'));
if isempty(entries), entries = emptyOut; return; end

% Stable sort: first by name (tie-breaker), then by datenum ascending.
[~, nameOrder] = sort({entries.name});
entries = entries(nameOrder);
[~, dateOrder] = sort([entries.datenum], 'ascend');
entries = entries(dateOrder);
end
