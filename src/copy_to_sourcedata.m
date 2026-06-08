function copy_to_sourcedata(cfg, dcm)
% Copy a non-convertible DICOM folder verbatim into the BIDS sourcedata/
% directory. Used for data that cannot be converted to NIfTI (e.g. the
% Siemens TENSOR diffusion series) but should still be preserved in the
% dataset in its original format.
%
% The destination subfolder name is taken from dcm.sourcedata, not from
% the original DICOM folder name. The resulting layout is:
%   sourcedata/sub-XX/ses-YY/<data_type>/<dcm.sourcedata>/

dest_folder = fullfile(cfg.bids_directory, 'sourcedata', ...
    cfg.subject_id, cfg.session_id, dcm.data_type, dcm.sourcedata);

% Create the destination folder if it does not exist:
if ~exist(dest_folder, 'dir')
    mkdir(dest_folder);
end

% cfg.dcm_folder holds the already resolved source folder. copyfile on a
% directory copies its CONTENTS into the destination folder.
copyfile(cfg.dcm_folder, dest_folder);

fprintf(['      > Copied to sourcedata: ' char(dcm.sourcedata) ' \n']);

end
