function command = generate_conversion_command(cfg,dcm)

if isfield(dcm, 'derivatives') && 0
    command{1} = sprintf('dcm2niix -f "%s" -z "%s" -ba "%s" -o "%s" "%s"', cfg.file_name, cfg.dataFormat, cfg.anonymization, cfg.derivativeFolder, cfg.dcm_folder);

else
    if strcmp(dcm.data_type,'mrs')
        % This is necessary because on Linux systems the
        % "spec2nii auto" command does not work when given a directory
        % as an argument; the .dcm file must be passed directly. If the
        % folder contained additional .dcm files, a loop would be needed
        % to generate commands for each file. For now we assume that
        % each folder only contains a single spectroscopy .dcm to
        % convert.

        files_list = dir(fullfile(cfg.dcm_folder, '*.dcm'));
        files_list = files_list(~startsWith({files_list.name}, '.'));
        
        if ~isempty(files_list)
            cfg.dcm_folder = fullfile(files_list(1).folder, ...
                files_list(1).name);
        end

        % Data anonymization in spec2nii is done in several steps:
        % first the original DICOM is converted to NIFTI, then the
        % fields we want to anonymize are removed, and finally we
        % extract the JSON with the anonymized metadata.
        if strcmp(cfg.anonymization,'y')
            
            % Convert
            command{1} = sprintf('spec2nii auto "%s" -o "%s" -f "%s"', cfg.dcm_folder, cfg.out_folder, cfg.file_name);

            % Anonymize
            command{2} = sprintf('spec2nii anon "%s" -r PatientName -r PatientWeight -r PatientDoB -r PatientSex -v -o "%s" -f "%s"', fullfile(cfg.out_folder,  cfg.file_name), cfg.out_folder, cfg.file_name);

            % Extract the JSON:
            command{3} = sprintf('spec2nii extract "%s" ', fullfile(cfg.out_folder,  cfg.file_name));

        else
            command{1} = sprintf('spec2nii auto "%s" -o "%s" -f "%s" -j', cfg.dcm_folder, cfg.out_folder, cfg.file_name);
        end
    else
        command{1} = sprintf('dcm2niix -f "%s" -z "%s" -ba "%s" -o "%s" "%s"', cfg.file_name, cfg.data_format, cfg.anonymization, cfg.out_folder, cfg.dcm_folder);
    end
end
end

