function start_bids_conversion(cfg,dcm,subjects)
fprintf('\n<strong>Starting NIFTI-BIDS conversion: </strong> \n');
%% DICOM to NIFTI.
% Start conversion accordig to BIDS standard.

% Iterate over subjects:
for i = 1 : subjects.n
    %% Check subject name
    % If the subject's folder already exists, it will be renamed in order 
    % to avoid losing data. 
    
    cfg.subject_id = subjects.ids{i};
    rename_existing_subject(cfg);

    %% Get sessions list
    % Search for subfolders in subject's main folder.
    
    sessions = get_sessions_list(cfg, subjects.sessions{i});
    
    %% Iterate over sessions:
    for j = 1 : numel(sessions)
        
        % Session ID:
        cfg.session_id = sessions{j}.id;

        fprintf(['\n <strong> > Subject id: </strong>' cfg.subject_id]);
        fprintf([' > <strong>Session id: </strong>' cfg.session_id '\n']);

        for k = 1 : numel(dcm)
            if ~isempty(dcm{k})
                %% Output folder:
                % Define the output path so that it complies with the BIDS
                % standard. The hierarchy should be:
                % Subject > Session > Data type.
                % If the current entry is flagged as derivative
                % (dcm{k}.derivatives = '<pipeline-name>'), the output is
                % placed under derivatives/<pipeline>/sub-XX/ses-YY/...
                % as required by the BIDS specification.

                % Original DICOM folder to convert:
                cfg.dcm_folder = fullfile(sessions{j}.path, ...
                    dcm{k}.folder);

                % Output directory:
                if isfield(dcm{k}, 'derivatives') && ~isempty(dcm{k}.derivatives)
                    initialize_derivatives_pipeline(cfg, dcm{k}.derivatives);
                    cfg.out_folder = fullfile(cfg.bids_directory, ...
                        'derivatives', dcm{k}.derivatives, ...
                        cfg.subject_id, cfg.session_id, dcm{k}.data_type);
                else
                    cfg.out_folder = fullfile(cfg.bids_directory, ...
                        cfg.subject_id, cfg.session_id, dcm{k}.data_type);
                end

                %% Generate BIDS-compatible filename:
                % This filename is generated based on the data provided for 
                % the current folder (modality, task, run, events, etc.)

                cfg = generate_bids_filename(cfg, dcm{k});

                %% Get dcm folder to convert: 
                % Retrieve the directories where the raw data to be 
                % converted are located. 

                cfg = get_dcm_folder(cfg);

                % If no folder found, continue.
                if isempty(cfg.dcm_folder); continue; end

                %% Convert DICOM - NIFTI:
                % Conversion routine. Here we will make system calls that 
                % convert the raw DICOM data into NIfTI format with file 
                % names and a structure compatible with the BIDS standard.

                dicom_to_bids(cfg,dcm{k});

                %% Import TSV:
                % If the data correspond to a task, we must also import the TSV
                % files specifying the onset and duration of the events.

                import_tsv_file(cfg, dcm{k});

            end
        end
    end
end

fprintf('\n<strong>Conversion completed! </strong> \n');

end