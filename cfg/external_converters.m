%% Paths to external converters:
%  Paths to the external packages required to perform the DICOM to NIFTI
%  conversion. Both packages must be installed on the machine and must be
%  accessible from a system call via the MATLAB system command.

%% Add containing folders to the PATH:
%  Add the path of both the dcm2niix and spec2nii packages:

% Linux (configuration for myccu3.ugr.es)
setenv('PATH', [getenv('PATH') ':/opt/homebrew/bin']);

%% Verify access
%  Check whether we can access the converters from MATLAB's system call.
%  This must be done for the different operating systems.

fprintf('<strong>Checking data converters: </strong> \n');

if ispc
    [dcm_status_check, dcm_cmdout_check] = system('where dcm2niix');
    [spe_status_check, spe_cmdout_check] = system('where spec2nii');
else
    [dcm_status_check, dcm_cmdout_check] = system('which dcm2niix');
    [spe_status_check, spe_cmdout_check] = system('which spec2nii');
end

%% Notify
%  Issue a warning to the user if either of the two converters is not
%  accessible by the program.

if dcm_status_check ~= 0
    fprintf('  - <strong>Warning:</strong> dcm2niix is not accesible. \n');
    fprintf(['  - <strong>CMDOUT:</strong>' dcm_cmdout_check '\n']);
else
    fprintf('  - Data converter dcm2niix > <strong>OK</strong> \n');
end

if spe_status_check ~= 0
    fprintf('  - <strong>Warning:</strong> spec2nii is not accesible. \n');
    fprintf(['  - <strong>CMDOUT:</strong>' spe_cmdout_check '\n']);
else
    fprintf('  - Data converter spec2nii > <strong>OK</strong> \n');
end

%% Clear the workspace:
clear spe_cmdout_check spe_status_check dcm_cmdout_check dcm_status_check