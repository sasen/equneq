function [stimfilename, trials] = makeMix(m1,m2)
% function [stimfilename, trials] = makeMix(m1,m2)
% DO NOT USE !!! Use makeStim instead to get paired Mixed trials
% makeMix  combine make Same and Diff trials for two ratios: m1/m2 and m2/m1
%  m1, m2 (pos real): means 1 and 2 for the sets.
%  stimfilename (string): .mat filename to load in main experiment
%  trials (struct array): trialTypes 1-4 of m1/m2 and m2/m1
%% FIXME: I really want Mix to grab the Same and Diff trials and reuse them!!
disp(mfilename)
disp('Promise me you know what you are doing.')
return
% [samefname, sTr] = makeSame(m1,m2);
% [difffname, dTr] = makeDiff(m1,m2);
% trials = shuffle([sTr; dTr]);

% stimfilename = strcat('mix_',num2str(m1),'_',num2str(m2),'.mat')
% save(stimfilename,'trials');