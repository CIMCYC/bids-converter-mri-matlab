function command = generateCommand(cfg,dcm)
if isfield(dcm, 'derivatives') && 0
    command = sprintf('dcm2niix -f "%s" -z "%s" -o "%s" "%s"', ...
        cfg.fileName, cfg.dataFormat, cfg.derivativeFolder, cfg.inFolder);
else
    if strcmp(dcm.dataType,'mrs')
        command = sprintf('spec2nii auto "%s" -o "%s" -f "%s" -j', ...
            cfg.inFolder, cfg.outFolder, cfg.fileName);
    else
        command = sprintf('dcm2niix -f "%s" -z "%s" -o "%s" "%s"', ...
            cfg.fileName, cfg.dataFormat, cfg.outFolder, cfg.inFolder);
    end
end
end

