function update_json(json_file,fields)

if isempty(json_file) || ~exist(json_file, 'file')
    return;
end

% Read json file:
json_data = jsondecode(fileread(json_file));

% Fields to add:
fn = fieldnames(fields);

for i = 1:numel(fn)
    json_data.(fn{i}) = fields.(fn{i});
    fprintf(['      > JSON key <' char(fn{i}) '> updated.  \n']);
end

% Encode JSON
if verLessThan('matlab','9.10')
    json_text = jsonencode(json_data);
else
    json_text = jsonencode(json_data, 'PrettyPrint', true);
end

% Save updated JSON
fid = fopen(json_file, 'w');
assert(fid ~= -1, 'Cannot create JSON file');
fwrite(fid, json_text, 'char');
fclose(fid);

end