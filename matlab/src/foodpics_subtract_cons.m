function foodpics_subtract_cons(con_name, subject_spm_dir, subject_dir)
%% function foodpics_subtract_cons(con_name, subject_spm_dir, subject_dir)
% con_name: name of contrast file to subtract across sessions without .nii extension
% subject_spm_dir: folder within subject/session directory containing spm first level results
% subject_dir: full path to subject directory containing session directories
% assumes the following session directories: 
%   ses-01=pre_fasted
%   ses-02=pre_fed
%   ses-03=post_fasted
%   ses-04=post_fed
% Example: foodpics_subtract_cons('con_003', 'foodpics_firstlevel','/data/images/adak/data/bids_data/derivatives/adak_foodpics/sub-204')

pre_fasted = 'ses-01';        % pre-intervention session fasted
pre_fed = 'ses-02';           % pre-intervention session fed
post_fasted = 'ses-03';       % post-intervention session fasted
post_fed = 'ses-04';          % post-intervention session fed



%% Compare fasted and fed scans

    % pre fast - fed  
    new_con_name=[con_name '_fastfed'];     % name of new contrast file comparing fasted and fed

    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,pre_fasted,subject_spm_dir), [con_name '.nii'], 1)    % pre-intervention con file fasted
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,pre_fed,subject_spm_dir), [con_name '.nii'], 1)       % pre-intervention con file fed
    
    batch_dir=fullfile(subject_dir,pre_fasted,subject_spm_dir)                                                % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fasted,subject_spm_dir,[new_con_name '.nii'])   % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)

    % post fast - fed 
    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,post_fasted,subject_spm_dir), [con_name '.nii'], 1)    % post-intervention con file fasted
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,post_fed,subject_spm_dir), [con_name '.nii'], 1)       % post-intervention con file fed
    
    batch_dir=fullfile(subject_dir,post_fasted,subject_spm_dir)                       % put batch in post-intervention folder
    new_con_nii=fullfile(subject_dir,post_fasted,subject_spm_dir,[new_con_name '.nii']) % put results in post-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)


    % pre fed - fast 
    new_con_name=[con_name '_fedfast'];     % name of new contrast file comparing fed - fasted

    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,pre_fed,subject_spm_dir), [con_name '.nii'], 1)       % pre-intervention con file fed
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,pre_fasted,subject_spm_dir), [con_name '.nii'], 1)    % pre-intervention con file fasted
    
    batch_dir=fullfile(subject_dir,pre_fasted,subject_spm_dir)                        % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fasted,subject_spm_dir,[new_con_name '.nii'])  % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)


    % post fed - fast 
    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,post_fed,subject_spm_dir), [con_name '.nii'], 1)       % post-intervention con file fed
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,post_fasted,subject_spm_dir), [con_name '.nii'], 1)    % post-intervention con file fasted
    
    batch_dir=fullfile(subject_dir,post_fasted,subject_spm_dir)                       % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,post_fasted,subject_spm_dir,[new_con_name '.nii']) % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)

%% Compare pre and post scans

    % fasted pre - post
    new_con_name=[con_name '_prepost'];     % name of new contrast file comparing fasted pre - post

    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,pre_fasted,subject_spm_dir), [con_name '.nii'], 1)    % pre-intervention con file fasted
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,post_fasted,subject_spm_dir), [con_name '.nii'], 1)   % post-intervention con file fasted
    
    batch_dir=fullfile(subject_dir,pre_fasted,subject_spm_dir)                                                % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fasted,subject_spm_dir,[new_con_name '.nii'])   % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)

    % fed pre - post
    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,pre_fed,subject_spm_dir), [con_name '.nii'], 1)    % pre-intervention con file fed
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,post_fed,subject_spm_dir), [con_name '.nii'], 1)   % post-intervention con file fed
    
    batch_dir=fullfile(subject_dir,pre_fed,subject_spm_dir)                                                % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fed,subject_spm_dir,[new_con_name '.nii'])   % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)

    % fasted post - pre
    new_con_name=[con_name '_postpre'];     % name of new contrast file comparing fasted post - pre

    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,post_fasted,subject_spm_dir), [con_name '.nii'], 1)    % post-intervention con file fasted
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,pre_fasted,subject_spm_dir), [con_name '.nii'], 1)   % pre-intervention con file fasted
    
    batch_dir=fullfile(subject_dir,pre_fasted,subject_spm_dir)                                                % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fasted,subject_spm_dir,[new_con_name '.nii'])   % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)

    % fed post - pre
    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,post_fed,subject_spm_dir), [con_name '.nii'], 1)     % post-intervention con file fed
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,pre_fed,subject_spm_dir), [con_name '.nii'], 1)      % pre-intervention con file fed
    
    batch_dir=fullfile(subject_dir,pre_fed,subject_spm_dir)                                                % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fed,subject_spm_dir,[new_con_name '.nii'])   % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)


%% Interaction contrasts

    % pre (fast - fed) - post (fast - fed) 
    con_name_sub=[con_name '_fastfed'];           % fasted - fed
    new_con_name=[con_name_sub '_prepost'];     % name of new contrast file comparing fasted and fed, pre - post

    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,pre_fasted,subject_spm_dir), [con_name_sub '.nii'], 1)    % pre-intervention con file fasted-fed
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,post_fasted,subject_spm_dir), [con_name_sub '.nii'], 1)   % post-intervention con file fasted-fed
    
    batch_dir=fullfile(subject_dir,pre_fasted,subject_spm_dir)                  % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fasted,subject_spm_dir,new_con_name)     % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)

    
    % post (fast - fed) - pre (fast - fed) 
    new_con_name=[con_name_sub '_postpre'];     % name of new contrast file comparing fasted and fed, post - pre

    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,post_fasted,subject_spm_dir), [con_name_sub '.nii'], 1)  % post-intervention con file fasted-fed
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,pre_fasted,subject_spm_dir), [con_name_sub '.nii'], 1)   % pre-intervention con file fasted-fed
    
    batch_dir=fullfile(subject_dir,pre_fasted,subject_spm_dir)                  % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fasted,subject_spm_dir,new_con_name)     % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)


    % pre (fed - fast) - post (fed - fast) 
    con_name_sub=[con_name '_fedfast'];            % fasted - fed
    new_con_name=[con_name_sub '_prepost'];     % name of new contrast file comparing fasted and fed, pre - post

    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,pre_fasted,subject_spm_dir), [con_name_sub '.nii'], 1)    % pre-intervention con file fed-fasted
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,post_fasted,subject_spm_dir), [con_name_sub '.nii'], 1)   % post-intervention con file fed-fasted
    
    batch_dir=fullfile(subject_dir,pre_fasted,subject_spm_dir)                  % put batch in pre-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fasted,subject_spm_dir,new_con_name)     % put results in pre-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)


    % post (fed - fast) - pre(fed - fast) 
    new_con_name=[con_name_sub '_postpre'];     % name of new contrast file comparing fed and fasted, post - pre

    con_nii_1=spm_select('ExtFPList', fullfile(subject_dir,post_fasted,subject_spm_dir), [con_name_sub '.nii'], 1)  % post-intervention con file fed-fasted
    con_nii_2=spm_select('ExtFPList', fullfile(subject_dir,pre_fasted,subject_spm_dir), [con_name_sub '.nii'], 1)   % pre-intervention con file fed-fasted
    
    batch_dir=fullfile(subject_dir,pre_fasted,subject_spm_dir)                  % put batch in post-intervention folder
    new_con_nii=fullfile(subject_dir,pre_fasted,subject_spm_dir,new_con_name)     % put results in post-intervention spm folder
    
    spm_subtract_cons(con_nii_1, con_nii_2, new_con_nii, batch_dir)



end

