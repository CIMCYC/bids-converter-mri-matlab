function initialize_bids_dataset(cfg)

fprintf('\n<strong>Initializing BIDS dataset: </strong> \n');

%% BIDS database folder
%  Create the output folder if it does not exist. 

if ~exist(cfg.bids_directory, 'dir')
    mkdir(cfg.bids_directory);
end

%% Dataset description file.
%  Generate dataset description file (dataset_description.json) if it does
%  not exist.

json_file = fullfile(cfg.bids_directory, 'dataset_description.json');

if cfg.dataset_description.flag && ~exist(json_file, 'file')

    if verLessThan('matlab','9.10')
        data = jsonencode(cfg.dataset_description.json);
    else
        data = jsonencode(cfg.dataset_description.json,'PrettyPrint',true);
    end

    fid = fopen(fullfile(cfg.bids_directory,'dataset_description.json'),'w');
    if fid == -1, error('Cannot create JSON file'); end
    fwrite(fid, data, 'char');
    fclose(fid);

    fprintf('  - Dataset description file > <strong>OK</strong> \n');

end

%% LICENSE file.
% Import the selected LICENSE file if needed and if it does not exist.

license = fullfile(cfg.bids_directory, 'LICENSE');

if cfg.dataset_description.include_license && ~exist(license, 'file')
    if ~isempty(cfg.dataset_description.json.License)
        file = ['templates/licenses/' cfg.dataset_description.json.License];
        copyfile(file, fullfile(cfg.bids_directory, 'LICENSE'));
        fprintf('  - License file > <strong>OK</strong> \n');
    end
end

%% README file.
%  Generate an empty README file if needed and if it does not exist.

readme = fullfile(cfg.bids_directory, 'README');

if cfg.dataset_description.include_readme && ~exist(readme, 'file')
    file = 'templates/README';
    copyfile(file, fullfile(cfg.bids_directory, 'README'));
    fprintf('  - README file (empty) > <strong>OK</strong> \n');
end

%% CHANGES file.
%  Generate an empty CHANGES file if needed and if it does not exist.

changes = fullfile(cfg.bids_directory, 'CHANGES');

if cfg.dataset_description.include_changes && ~exist(changes, 'file')
    changes_log = [char(datetime("today")) ' - Project creation.'];
    fid = fopen(fullfile(cfg.bids_directory,'CHANGES'), 'w', 'n', 'UTF-8');
    if fid == -1, error('Cannot create CHANGES file'); end
    fprintf(fid, '%s\n', changes_log);
    fclose(fid);
    fprintf('  - CHANGES file (empty) > <strong>OK</strong> \n');
end

%% BIDSIGNORE file.
% Import .bidsignore file if needed and if it does not exist.

bidsignore = fullfile(cfg.bids_directory, '.bidsignore');

if cfg.dataset_description.include_bidsignore && ~exist(bidsignore, 'file')
    file = 'templates/.bidsignore';
    copyfile(file, fullfile(cfg.bids_directory, '.bidsignore'));
    fprintf('  - .bidsignore file > <strong>OK</strong> \n');
end

end

