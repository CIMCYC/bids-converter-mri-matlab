%% Rutas a los conversores externos:
%  Rutas a los paquetes externos necesarios para poder hacer la conversión
%  de DICOM a NIFTI. Estos dos paquetes deben estar instalados en el equipo
%  y deben ser accesibles desde la llamada al sistema con el comando system
%  de MATLAB.

%% Añadimos carpetas contenedoras al PATH:
%  Añadimos la ruta tanto del paquete dcm2niix como spec2nii:

% Linux (configuración para myccu3.ugr.es)
% setenv('PATH', [getenv('PATH') ':/usr/local/fsl/bin']);

%% Verificar acceso
%  Vamos a verificar si podemos acceder a los conversores desde el system
%  de MATLAB. Debemos hacerlo para los distintos sistemas operativos.

if ispc
    [dcm_status_check, dcm_cmdout_check] = system('where dcm2niix');
    [spe_status_check, spe_cmdout_check] = system('where spec2nii');
else
    [dcm_status_check, dcm_cmdout_check] = system('which dcm2niix');
    [spe_status_check, spe_cmdout_check] = system('which spec2nii');
end

%% Notificar
%  Enviar un warning al usuario si alguno de los dos conversores no es
%  accesible por el programa.

if dcm_status_check ~= 0
    warning('dcm2niix no se encuentra en el PATH. cmdout: %s', ...
        dcm_cmdout_check);
else
    disp('Data converter dcm2niix > OK');
end

if spe_status_check ~= 0
    warning('spec2nii no se encuentra en el PATH. cmdout: %s', ...
        spe_cmdout_check);
else
    disp('Data converter spec2nii > OK');
end
