function generate_empty_tsv(cfg, dcm)
if strcmp(dcm.data_type, 'func')
    %% Generate the events TSV file.
    % The BIDS standard requires an events.tsv file for functional MRI
    % data. This function generates an empty template with the mandatory
    % columns: "onset" and "duration".
    % Important: This file is a placeholder. The actual onset and duration
    % values must be filled in by the user before running any analysis.

    % Build the full output path:
    output_path = fullfile(cfg.outFolder, cfg.eventsFileName);

    % Write the file:
    fid = fopen(output_path, 'w');
    if fid == -1
        error('Could not create file: %s', output_path);
    end

    % Add the mandatory headers required by the BIDS standard:
    fprintf(fid, 'onset\tduration\n');

    % Close the file once written:
    fclose(fid);

    fprintf('     > Empty events TSV file generated \n');

end
end
