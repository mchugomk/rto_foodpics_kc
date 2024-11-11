function [rp_file, dvars_file, fd_file]=get_mot_params(confound_file)
% Extract realignment params, DVARS, and FD from fmriprep confound file
% and calculate summary statistics
% Requires Matlab >= R2019b


[confound_path,confound_name,confound_ext]=fileparts(confound_file);                % input confounds file from fmriprep
rp_file=fullfile(confound_path, ['rp_' confound_name '.txt']);                      % output file for realignment params
dvars_file=fullfile(confound_path, ['dvars_' confound_name '.txt']);                % output file for dvars
fd_file=fullfile(confound_path, ['fd_' confound_name '.txt']);                      % output file for fd
mot_summary_file=fullfile(confound_path, ['mot_summary_' confound_name '.txt']);    % output file for motion summary

% Specify columns to extract from confound file
rp_cols=["trans_x", "trans_y", "trans_z", "rot_x", "rot_y", "rot_z"];   % spm style realignment columns
dvars_col="dvars";                                                      % power dvars
fd_col="framewise_displacement";                                        % power FD
mot_cols=[rp_cols, dvars_col, fd_col];                                  % spm and power et al columns

% Read in confound file from fmriprep
opts=detectImportOptions(confound_file,'FileType','text');
conf_data=readtable(confound_file, opts);

% Extract motion columns
rp_data=conf_data{:, rp_cols};
dvars_data=conf_data{:, dvars_col};
fd_data=conf_data{:, fd_col};

% Write motion parameters for first level modeling
writematrix(rp_data, rp_file, 'Delimiter', '\t');
writematrix(dvars_data, dvars_file);
writematrix(fd_data, fd_file);

% Save summary stats for motion
% calc minimum, maximum, mean, sd, and median for realignment params, dvars, and fd
% - omitnan bc of dvars, fd
mot_data=[rp_data dvars_data fd_data];
mot_stat_names={'min'; 'max'; 'mean'; 'sd'; 'median'};
mot_min=min(mot_data, [], 1, 'omitnan');
mot_max=max(mot_data, [], 1, 'omitnan');
mot_mean=mean(mot_data, 'omitnan');
mot_sd=std(mot_data, 'omitnan');
mot_median=median(mot_data, 'omitnan');
mot_stats=[mot_min; mot_max; mot_mean; mot_sd; mot_median];

mot_stats_table=array2table(mot_stats, ...
        'VariableNames', mot_cols, ...
        'RowNames', mot_stat_names);
writetable(mot_stats_table, mot_summary_file, 'Delimiter', '\t', 'WriteRowNames', true);

end
