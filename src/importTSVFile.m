function importTSVFile(cfg, dcm)

if strcmp(dcm.dataType,'func') && cfg.importTSV && isfield(dcm, 'events')
    
    file = dir([dcm.folder filesep dcm.events]);
    filepath = fullfile(file.folder,file.name);
    filepath_ = [cfg.outFolder filesep cfg.eventsFileName];
    copyfile(filepath,filepath_);

end

end