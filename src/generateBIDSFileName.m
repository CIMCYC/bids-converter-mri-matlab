function [fileName, eventsFileName] = generateBIDSFileName(cfg, dcm)

%% Generate empty parameters:
dataType = char();
dataModality = char();
taskName = char();
runNumber = char();
eventsFileName = char();
direction = char();

%% Extract data information:
if isfield(dcm, 'dataType')
    dataType  = dcm.dataType;
end

if isfield(dcm, 'modality')
    dataModality  = dcm.modality;
end

if isfield(dcm, 'task')
    taskName  = dcm.task;
end

if isfield(dcm, 'run')
    runNumber  = dcm.run;
end

if isfield(dcm, 'dir')
    direction  = dcm.dir;
end


%% Generate the file depending on dataType name:
if strcmp(dataType,'func')

    fileName = [cfg.subjectId '_' cfg.sessionName '_' taskName '_' ...
        direction '_' runNumber '_' dataModality];

    eventsFileName = [cfg.subjectId '_' cfg.sessionName '_' taskName '_' ...
        runNumber '_events.tsv' ];

elseif strcmp(dataType,'fmap')

    fileName = [cfg.subjectId '_' cfg.sessionName '_' direction '_' ...
        runNumber];

elseif strcmp(dataType,'dwi')

    fileName = [cfg.subjectId '_' cfg.sessionName '_' direction '_' ...
        runNumber '_' dataModality];
    
else
    fileName = [cfg.subjectId '_' cfg.sessionName '_' dataModality];
end

%% Delete duplicate caracters:
fileName = removeDuplicateChar(fileName,'_');
eventsFileName = removeDuplicateChar(eventsFileName,'_');

end