function import_tsv_file(cfg, dcm)

if strcmp(dcm.data_type,'func') && isfield(dcm, 'import_empty_tsv')
    if dcm.import_empty_tsv
        generate_empty_tsv(cfg)
    end
    % file = dir([dcm.folder filesep dcm.events]);
    % filepath = fullfile(file.folder,file.name);
    % filepath_ = [cfg.out_folder filesep cfg.events_file_name];
    % copyfile(filepath,filepath_);
end
end