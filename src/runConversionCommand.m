function [status, cmdout] = runConversionCommand(cfg,command)
disp('Converting DICOM data from: ')
disp(cfg.inFolder)

% Ejecutamos la llamada al sistema:
[status, cmdout] = system(command);

% Mostramos el resultado:
if status ~= 0
    fprintf('Error ejecutando la conversión (status %d):\n%s\n', ...
        status, cmdout);
else
    disp('> Conversión completada correctamente.');
end
end

