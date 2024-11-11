%% marsbar - get percent signal change from all events in design matrix
%  Reference: https://marsbar-toolbox.github.io/faq.html#how-do-i-extract-percent-signal-change-from-my-design-using-batch
%  
%  Saves marsbar percent signal change estimate for each event in
%  design matrix. For each ROI specified, a tab-delimited text file 
%  named <roi name>_psc.txt will be created in the output directory (out_dir).
%  Each row will contain the percent signal change data for a different 
%  subject specified in slist and session specified in seslist.
%  The script assumes that all event names are the same across all runs and
%  subjects. The event names will be saved in the output directory as e_names.txt 
%
%  Be careful when using data from sessions where only a single run was
%  included. This script doesn't differentiate between whether the first or
%  second foodpics run was included in the task design and will save the
%  percent signal change data in the first 3 columns as if it was from 
%  run 1. 


%% Study specific variables to specify data folders
task_id='foodpics';
firstlevel_subdir=[task_id '_firstlevel'];
spm_name = 'SPM.mat';
dur=16; % SPECIFY EVENT/BLOCK DURATION in seconds

study_dir='/home/data/images/rto';
data_dir=fullfile(study_dir,'data');
firstlevel_dir=fullfile(data_dir,'bids_data','derivatives',['rto_' task_id '_kc']);
out_dir=fullfile(data_dir,'group_analysis',['rto_' task_id '_kc'],'marsbar'); 
roi_dir=fullfile(data_dir, 'rois', ['rto_' task_id '_kc']); 


%% ROI files - included as example only
rois={fullfile(roi_dir, 'L_insula_mask_3mm_-33_16_-6_roi.mat')
}

%% list of subjects to process
slist={'sub-300'
% 'sub-301'
% 'sub-302'
% 'sub-303'
% 'sub-304'
% 'sub-305'
% 'sub-306'
% 'sub-307'
% 'sub-309'
% 'sub-310'
% 'sub-311'
% 'sub-312'
% 'sub-313'
% 'sub-314'
% 'sub-315'
% 'sub-317'
% 'sub-319'
% 'sub-320'
% 'sub-322'
};

% Run for all sessions
seslist={'ses-01'
% 'ses-02'
% 'ses-03'
% 'ses-04'
}




% Start marsbar to make sure spm_get works
marsbar('on')


% Set up the SPM defaults, just in case
spm('defaults', 'fmri');



%% loop over subjects 
for s=1:length(slist)
    subject_id=slist{s}

    for ses=1:length(seslist)
        session=seslist{ses}

        % loop over rois
        for r=1:length(rois)
    
            roi_file=rois{r}
            [p, n, e] = fileparts(roi_file);
            
            filename = fullfile(out_dir,[n '_psc'])
            if (s==1 & ses==1)
                fid = fopen([filename '.txt'],'w') % overwrite existing file
            else
                fid = fopen([filename '.txt'],'a') % append to existing file
            end
            
                  
            % write subject id to file
            fprintf(fid, '%s\t%s\t',subject_id, session);
            
            % Directory to load ROIs
%             subjroot=fullfile(data_dir, subject_id, session, firstlevel_dir);
            subjroot=fullfile(firstlevel_dir, subject_id, session, firstlevel_subdir);
            cd(subjroot)
    
            % Make marsbar design object by setting path to SPM file with design
            D  = mardo(spm_name)
    
            % Make marsbar ROI object by setting path to specified ROI file
            R  = maroi(roi_file)
    
            % Fetch data into marsbar data object
            % extract data from ROI
            Y  = get_marsy(R, D, 'mean');
    
            % Estimate design on ROI data
            E = estimate(D, Y);
    
            %------------for each run separately--------------
    
            % Get definitions of all events in model
            [e_specs, e_names] = event_specs(E);
            n_events = size(e_specs, 2);
            disp(e_names)
            
            % Change this dur to = the length of the event
            % dur = 16;
    
            % Return percent signal estimate for all events in design    
            clear pct_ev
            for e_s = 1:n_events
                pct_ev(e_s) = event_signal(E, e_specs(:,e_s), dur);
                fprintf(fid,'%.3f\t', pct_ev(e_s));
            end
            fprintf(fid,'%s\n','');
    
            % save percent signal change data to another object
            % pct_signal(s,1:n_events)=pct_ev % change 1, for single subject, to s, if looping over subjects
    
            fclose(fid); % close text file
        end

    end
    
    
end

% Save event names
writecell(e_names, fullfile(out_dir,'e_names.txt'), 'Delimiter', '\t');
