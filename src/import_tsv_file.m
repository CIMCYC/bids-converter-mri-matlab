function import_tsv_file(cfg, dcm)

if strcmp(dcm.data_type,'func') && cfg.import_tsv && isfield(dcm, 'events')
    
    file = dir([dcm.folder filesep dcm.events]);
    filepath = fullfile(file.folder,file.name);
    filepath_ = [cfg.outFolder filesep cfg.eventsFileName];
    copyfile(filepath,filepath_);

end

end