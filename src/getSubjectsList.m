function subjects = getSubjectsList(cfg)
% DISCOVER_BIDS_SUBJECTS
% Busca subcarpetas de participantes en una carpeta raíz.
%
% Cada subcarpeta:
%   - debe ser directorio
%   - no puede ser '.' ni '..'
%   - el nombre será el subject ID
%
% OUTPUT:
%   subjects.root
%   subjects.ids
%   subjects.paths
%   subjects.n

%% Validar carpeta raíz:
% Comporbamos que la carpeta proporcionada existe y realmente sea una
% carpeta.

root_dir = cfg.rawDICOM;

if ~isfolder(root_dir)
    error('La ruta proporcionada no existe o no es una carpeta:\n%s', root_dir)
end

root_dir = char(root_dir);

%% Listamos el contenido:
% Listamos el contenido completo de la carpeta. Además, eliminamos las
% entradas que contienen '.' y '..' muy comunes. Comporbamos además que la
% carpeta no esté vacía.

subjectsList = dir(root_dir);
subjectsList = subjectsList(~ismember({subjectsList.name}, {'.','..'}));

if isempty(subjectsList)
    error('La carpeta está vacía: %s', root_dir)
end

%% Filtramos solo directorios:
% Nos quedamos solo con los directorios, eliminando posibles archivos
% contenidos en la carpeta raíz que no se correspondan con carpetas de
% participantes.

is_dir = [subjectsList.isdir];
subjectsList = subjectsList(is_dir);

if isempty(subjectsList)
    error('No se encontraron subcarpetas de participantes en: %s', root_dir)
end

%% Comporbamos que los nombres de los sujetos son válidos.
% El nombre de cada carpeta se usará como subject ID para los datos
% transformados a BIDS. Por este motivo, debemos comprobar que los
% caracteres sean alfanuméricos (debemos evitar el uso de - o _).

subjectIDs = {};
subjectPaths = {};

for i = 1:numel(subjectsList)

    subjectName = subjectsList(i).name;

    % Evitar carpetas ocultas tipo .DS_Store o .git
    if startsWith(subjectName, '.')
        continue
    end

    % Generamos la ruta completa a la carpeta del participante.
    subjectPath = fullfile(root_dir, subjectName);

    % Comprobación extra robusta
    if ~isfolder(subjectPath)
        continue
    end

    % Validar nombre BIDS-compatible
    validateSubjectName(subjectName)

    % Almacenamos el nombre y el path del participante.
    subjectIDs{end+1} = ['sub-' subjectName];
    subjectPaths{end+1} = [subjectPath filesep cfg.ip];

end

%% Comprobaciones finales:
% Realizamos algunas comprobaciones finales como que existan rutas válidas
% para los participantes o que no existan nombres repetidos de los mismos.

if isempty(subjectIDs)
    error('No se encontraron carpetas válidas de participantes.')
end

if numel(unique(subjectIDs)) ~= numel(subjectIDs)
    error('Hay IDs de sujeto duplicados.')
end

%% Creamos estructura de salida

subjects = struct();
subjects.root = root_dir;
subjects.ids = subjectIDs;
subjects.paths = subjectPaths;
subjects.n = numel(subjectIDs);

end

%% Función de validación alfanumérica:
function validateSubjectName(name)
if isempty(regexp(name, '^[a-zA-Z0-9]+$', 'once'))
    error(['Nombre de sujeto no válido para BIDS:\n' ...
        '  "%s"\n' ...
        'Solo caracteres alfanuméricos permitidos.'], name)
end
end