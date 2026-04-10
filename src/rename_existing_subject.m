function rename_existing_subject(cfg)
%% Rename existing subject folder.
% If the subject folder already exists, rename it by appending a unique
% suffix based on the current time to avoid overwriting previous results.
% The rename is done at the subject level so that all its sessions and
% data types are preserved together.

subject_folder = string(fullfile(cfg.bids_directory, cfg.subject_id));

if exist(subject_folder, 'dir')
    rng('shuffle');
    suffix = sprintf('_%04d', randi(9999));
    movefile(subject_folder, subject_folder + suffix);
    fprintf('\n  <strong>> WARNIG:</strong> Existing subject folder renamed to %s \n', ...
        string(cfg.subject_id) + suffix);
end

end
