%% Rutas a los conversores externos:
%  Rutas a los paquetes externos necesarios para poder hacer la conversión
%  de DICOM a NIFTI. Estos dos paquetes deben estar instalados en el equipo
%  y deben añadirse al path de MATLAB para que sean accesibles desde el
%  comando system:

%% Paquete dcm2niix: Necesario para todas las conversiones.
%  Añadimos la ruta al path de MATLAB:
addpath('C:\Program Files\dcm2niix_win\');

%% Paquete spec2nii: Necesario para datos de espectroscopía.
%  Añadimos la ruta al path de MATLAB:
addpath('C:\Users\David\AppData\Local\Python\pythoncore-3.14-64\Scripts\');

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
