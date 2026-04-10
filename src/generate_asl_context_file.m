function generate_asl_context_file(cfg, dcm)
if strcmp(dcm.data_type, 'perf') && strcmp(dcm.modality, 'asl')
    %% Build the control-label sequence.
    % Important: We assume that the sequence always starts with a "control"
    % followed by a "label", which is the standard Siemens/PCASL pattern.

    n_volumes = dcm.TotalAcquiredPairs * 2;
    context = strings(n_volumes, 1);

    for i = 1:dcm.TotalAcquiredPairs
        idx = (i-1)*2 + 1;
        context(idx) = "control";
        context(idx+1) = "label";
    end

    %% Append the M0scan.
    % Important: We also assume that, if the M0 volume is included, it
    % will be located at the end of the sequence. If that is not the
    % case, the sequence must be modified.

    if strcmp(dcm.M0Type,'Included')
        context = [context; "m0scan"];
    end

    %% Generate the TSV file.
    % First, build the full output path:

    output_path = fullfile(cfg.out_folder, cfg.context_filename);

    % Write the file
    fid = fopen(output_path, 'w');
    if fid == -1
        error('Could not create file: %s', output_path);
    end

    % Add the volume_type header required by the BIDS standard:
    fprintf(fid, 'volume_type\n');

    % Write the contents to the file:
    for i = 1:length(context)
        fprintf(fid, '%s\n', context(i));
    end

    % Close the file once written:
    fclose(fid);

    fprintf('     > ASL context file generated \n');

end
end

