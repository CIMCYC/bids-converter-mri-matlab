function command = generateCommand(cfg,dcm)
if isfield(dcm, 'derivatives') && 0
    command{1} = sprintf('dcm2niix -f "%s" -z "%s" -ba "%s" -o "%s" "%s"', cfg.fileName, cfg.dataFormat, cfg.anonymization, cfg.derivativeFolder, cfg.inFolder);
else
    if strcmp(dcm.dataType,'mrs')
        
        % This is necessary because on Linux systems the
        % "spec2nii auto" command does not work when given a directory
        % as an argument; the .dcm file must be passed directly. If the
        % folder contained additional .dcm files, a loop would be needed
        % to generate commands for each file. For now we assume that
        % each folder only contains a single spectroscopy .dcm to
        % convert.

        listOfFiles = dir(fullfile(cfg.inFolder, '*.dcm'));
        listOfFiles = listOfFiles(~startsWith({listOfFiles.name}, '.'));
        
        if ~isempty(listOfFiles)
            cfg.inFolder = fullfile(listOfFiles(1).folder, listOfFiles(1).name);
        end

        % Data anonymization in spec2nii is done in several steps:
        % first the original DICOM is converted to NIFTI, then the
        % fields we want to anonymize are removed, and finally we
        % extract the JSON with the anonymized metadata.
        if strcmp(cfg.anonymization,'y')
            % Convert
            command{1} = sprintf('spec2nii auto "%s" -o "%s" -f "%s"', cfg.inFolder, cfg.outFolder, cfg.fileName);

            % Anonymize
            command{2} = sprintf('spec2nii anon "%s" -r PatientName -r PatientWeight -r PatientDoB -r PatientSex -v -o "%s" -f "%s"', fullfile(cfg.outFolder,  cfg.fileName), cfg.outFolder, cfg.fileName);

            % Extract the JSON:
            command{3} = sprintf('spec2nii extract "%s" ', fullfile(cfg.outFolder,  cfg.fileName));

        else
            command{1} = sprintf('spec2nii auto "%s" -o "%s" -f "%s" -j', cfg.inFolder, cfg.outFolder, cfg.fileName);
        end
    else
        command{1} = sprintf('dcm2niix -f "%s" -z "%s" -ba "%s" -o "%s" "%s"', cfg.fileName, cfg.dataFormat, cfg.anonymization, cfg.outFolder, cfg.inFolder);
    end
end
end

