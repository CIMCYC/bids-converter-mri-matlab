function update_taskname_json(cfg,dcm)
%% FUNCTIONAL: TaskName problem in the sidecar JSON file:
if strcmp(dcm.data_type, 'func') && isfield(dcm, 'task')

    % Update TaskName field:
    fields.TaskName = dcm.task;

    % Get JSON file:
    json_file = fullfile(cfg.out_folder, cfg.file_name + ".json");

    % Update json file:
    update_json(json_file,fields)
end

end

