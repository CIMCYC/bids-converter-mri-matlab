function initialize_derivatives_pipeline(cfg, pipeline)
% Create the dataset_description.json required by BIDS inside a
% derivatives pipeline folder. The file is only written the first time
% the pipeline folder is encountered.

pipeline_folder = fullfile(cfg.bids_directory, 'derivatives', pipeline);

if ~exist(pipeline_folder, 'dir')
    mkdir(pipeline_folder);
end

json_file = fullfile(pipeline_folder, 'dataset_description.json');

if exist(json_file, 'file')
    return;
end

description.Name = pipeline;
description.BIDSVersion = cfg.dataset_description.json.BIDSVersion;
description.DatasetType = 'derivative';
description.GeneratedBy = {struct('Name', pipeline)};

if verLessThan('matlab','9.10')
    data = jsonencode(description);
else
    data = jsonencode(description, 'PrettyPrint', true);
end

fid = fopen(json_file, 'w');
if fid == -1, error('Cannot create derivatives JSON file'); end
fwrite(fid, data, 'char');
fclose(fid);

fprintf(['  - Derivatives pipeline "' pipeline '" initialized > <strong>OK</strong> \n']);

end
