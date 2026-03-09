function [status, cmdout] = runConversionCommand(cfg,command)
disp('Converting DICOM data from: ')
disp(cfg.inFolder)

% Ejecutamos las llamadas al sistema:
for i = 1 : length(command)
    [status, cmdout] = system(command{i});
end

% Mostramos el resultado:
if status ~= 0
    fprintf('Error ejecutando la conversión (status %d):\n%s\n', ...
        status, cmdout);
else
    disp('> Conversión completada correctamente.');
end
end

