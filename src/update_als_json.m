function update_als_json(cfg,dcm)

if strcmp(dcm.data_type, 'perf') && strcmp(dcm.modality, 'asl')

    % Fields to update:
    fields.M0Type = dcm.M0Type;
    fields.PostLabelingDelay = dcm.PostLabelingDelay;
    fields.BackgroundSuppression = dcm.BackgroundSuppression;
    fields.TotalAcquiredPairs = dcm.TotalAcquiredPairs;

    % Get JSON file:
    json_file = fullfile(cfg.out_folder, cfg.file_name + ".json");

    % Update json file ff not empty:
    update_json(json_file,fields)

end
end

