function generateASLContextFile(cfg, dcm)
if strcmp(dcm.dataType, 'perf') && strcmp(dcm.modality, 'asl')
    %% Generación de la secuencia control-label.
    % Importante: Asumimos que la secuencia comienza siempre por un "control"
    % seguido de un "label" que es el patrón estándar Siemens/PCASL.

    nVolumes = dcm.TotalAcquiredPairs * 2;
    context = strings(nVolumes, 1);

    for i = 1:dcm.TotalAcquiredPairs
        idx = (i-1)*2 + 1;
        context(idx) = "control";
        context(idx+1) = "label";
    end

    %% Añadimos el M0scan.
    % Importante: Asumimos además que de incluirse el volumen correspondiente
    % al M0, este se encontrará al final de la secuencia. Si ese no fuese el
    % caso, es necesario modificar la secuencia.

    if strcmp(dcm.M0Type,'Included')
        context = [context; "m0scan"];
    end

    %% Generación del archivo TSV.
    % En primer lugar, generamos la ruta completa:

    outputFilePath = fullfile(cfg.outFolder, cfg.contextFileName);

    % Escribimos el archivo
    fid = fopen(outputFilePath, 'w');
    if fid == -1
        error('No se pudo crear el archivo: %s', outputFilePath);
    end

    % Añadimos el header volume_type requerido en el estándar BIDS:
    fprintf(fid, 'volume_type\n');

    % Escribimos el contenido en el archivo:
    for i = 1:length(context)
        fprintf(fid, '%s\n', context(i));
    end

    % Cerramos el archivo una vez escrito:
    fclose(fid);

    fprintf('     > ASL context file generated \n');

end
end

