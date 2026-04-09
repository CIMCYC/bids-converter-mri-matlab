function sessions = get_sessions_list(cfg, sessions)
%% No sessions:
% If the user has indicated that they do not want to include sessions in 
% their dataset, we will select the first subfolder within the archive 
% folder as the folder to convert. Additionally, we need to remove the 
% session_id so that it is not included in the file names.
if ~cfg.sessions
    sessions = sessions(1);
    sessions{1}.id = '';
end

end