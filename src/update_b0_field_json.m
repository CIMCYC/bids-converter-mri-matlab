function update_b0_field_json(cfg, dcm)
%% Case 1: Functional or diffusion data:
% func or dwi data with an associated fmap identifier. We add the
% B0FieldSource field pointing to the corresponding fmap.

if any(strcmp(dcm.data_type, {'func', 'dwi'})) && isfield(dcm, 'fmapid')

    json_file = fullfile(cfg.out_folder, cfg.file_name + ".json");
    fields.B0FieldSource = dcm.fmapid;

end

%% Case 2: Fieldmap data:
% fmap data with an identifier. We add the B0FieldIdentifier field
% to the phasediff JSON sidecar.
if strcmp(dcm.data_type, 'fmap') && isfield(dcm, 'identifier')

    json_file = fullfile(cfg.out_folder,cfg.file_name + "_phasediff.json");
    json_file = remove_duplicate_char(json_file,'_');

    fields.B0FieldIdentifier = dcm.identifier;

end

%% JSONs modification:

if exist('json_file','var')

    update_json(json_file,fields)

end

end
