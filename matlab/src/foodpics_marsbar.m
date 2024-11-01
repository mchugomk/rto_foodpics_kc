% marsbar

% SPECIFY EVENT DURATION 
% dur=0; 
dur=16; % in seconds

% Data folder information
study_dir='/data/images/adak/data';
bids_dir=fullfile(study_dir,'bids_data');
data_dir=fullfile(bids_dir,'derivatives','adak_foodpics');
firstlevel_dir='foodpics_firstlevel';
spm_name = 'SPM.mat';

% Lauren practice folders
out_dir=fullfile(study_dir,'group_analysis','foodpics','psc', 'lauren'); 
roi_dir=fullfile(study_dir, 'rois', 'foodpics', 'lauren'); 


% roi files
rois={fullfile(roi_dir, 'harvardoxford-cortical_prob_InsularCortex_p25_-36_2_0_roi.mat')
}

% list of 'subjects to process
slist={'sub-204'
'sub-207'
'sub-209'
'sub-212'
'sub-213'
'sub-215'
'sub-216'
'sub-223'
'sub-225'
'sub-226'
'sub-227'
'sub-228'
'sub-229'
'sub-232'
'sub-235'
'sub-236'
'sub-237'
'sub-238'
'sub-239'
'sub-242'
'sub-244'
'sub-245'
'sub-246'
'sub-247'
'sub-248'
'sub-249'
'sub-250'
'sub-252'
'sub-254'
'sub-255'
'sub-256'
'sub-257'
'sub-258'
'sub-259'
'sub-260'
'sub-261'
'sub-262'
'sub-263'
'sub-266'
'sub-267'
'sub-268'    
};

seslist={'ses-01'
'ses-02'
'ses-03'
'ses-04'
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
            subjroot=fullfile(data_dir, subject_id, session, firstlevel_dir);
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
            %dur = 16;
    
            % Return percent signal estimate for all events in design
    
            clear pct_ev
            for e_s = 1:n_events
                pct_ev(e_s) = event_signal(E, e_specs(:,e_s), dur);
                fprintf(fid,'%.3f\t', pct_ev(e_s));
            end
            fprintf(fid,'%s\n','');
    
            % save percent signal change data to another object
            pct_signal(s,1:n_events)=pct_ev % change 1, for single subject, to s, if looping over subjects
    
            % save all data to a .mat data file
            fclose(fid); % close text file
        end

    end
    
    
end

writecell(e_names, fullfile(out_dir,'e_names.txt'), 'Delimiter', '\t')