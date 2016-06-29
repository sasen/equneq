How to do analysis for equneq

I. Preliminaries
  0. Requires the stimulus file used to run the experiment, or else psychometric curves will be scrambled and meaningless.
     Eg allStimuli123_6.mat (123=size of standard in px, 6=pairs). This file must be on the matlabpath!
  1. Put data at analysis/../DATA/. Each subj gets their own folder named hetXXX/, with 3 .mat files (starting with s, d, and m).
  2. Make or ensure the existence of analysis/work/nice_figs.
  3. Matlab working directory should be analysis/, or any directory in analysis's parent directory. (eg DATA/ should be ok.)
  4. (optional) Consider backing up: (NBD, can regenerate, but might reduce later confusion.)
    a. analysis/allSubjsFitarrays.mat. 
    b. analysis/work/nice_figs/group_muPlots.jpg

II. Fit psychometric functions for each subject
    NB: this takes a while, so don't refit old subjects if impatient. HOWEVER, group-level analysis currently requires all subjects' fits to be in one matfile! 
    (Sorry. Either patch that or go make a cup of tea.) SSTODOTODOFIXME
  1. Edit fitAllSubjs.m: Manually change/update the list of subjects to be analyzed. These are the "XXX" subject codes in the subject folder names.
  2. Run the script fitAllSubjs (beware, clear/close all). This saves all fits, produces individual figures, but doesn't save the figures.
     The fit parameters are in ms and ss, which are mu and sigma for a cumulative gaussian.

-. After this, you could come back and just run the script regenPlots, and that would load the fits and make+save figures (or 2 kinds??? not sure). 

III. Group level statistics
     This function is flexible enough to handle two types of subjects: different people ("group"), or one subject you've run multiple times ("indiv").
     I was interested in how consistent my own data would be, over multiple runs; that's what "indiv" means. These instructions assume you want "group".
  1. Edit mainStats.m: change/edit groupSID to be [1,2,3,...,N] where N is number of subjects you're analyzing.
  2. Call mainStats('group'). If you like boxes on your boxplots, there's an optional argument for that.
  3. If you want to look at sigma fits (~slope) instead of mu (PSE), uncomment the last chunk of mainStats.
