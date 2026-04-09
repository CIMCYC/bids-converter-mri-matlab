function generate_empty_tsv(cfg)
    %% Generate a fake events TSV file.
    % The BIDS standard requires an events.tsv file for functional MRI
    % data. This function generates a fake template with the mandatory
    % columns: "onset" and "duration", populated with random values.
    % Important: This file contains fake data intended for testing
    % purposes only. Replace the values with real experimental data
    % before running any analysis.

    %% Generate random onset and duration values.
    % Onset times are drawn from a uniform distribution between 0 and
    % 300 seconds, then sorted in ascending order to simulate a
    % realistic temporal sequence.
    % Duration values are drawn from a uniform distribution between
    % 0.5 and 5 seconds.

    n_events = 10;
    onsets = sort(rand(n_events, 1) * 300);
    durations = 0.5 + rand(n_events, 1) * 4.5;

    % Build the full output path:
    output_path = fullfile(cfg.out_folder, cfg.events_filename);

    % Write the file:
    fid = fopen(output_path, 'w');
    if fid == -1
        error('Could not create file: %s', output_path);
    end

    % Add the mandatory headers required by the BIDS standard:
    fprintf(fid, 'onset\tduration\n');

    % Write the fake event rows:
    for i = 1:n_events
        fprintf(fid, '%.4f\t%.4f\n', onsets(i), durations(i));
    end

    % Close the file once written:
    fclose(fid);

    fprintf('     > Fake events TSV file generated \n');

end
