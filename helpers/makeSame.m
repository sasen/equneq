function [stimfilename, trials] = makeSame(m1,m2)
%function stimfilename = makeSame(m1,m2)
% makeSame  make equal trials for both n=6 and n=12
%  m1, m2 (pos real): means 1 and 2 for the sets.
%  stimfilename (string): .mat filename to load in main experiment
%  trials (struct array): trialTypes 3 and 4 of m1/m2 and m2/m1
nA = 6; nB = 12; numTrials=20;
[stimAfname, trials1A] = makeEqual(nA,m1,m2,numTrials);
[stimBfname, trials1B] = makeEqual(nA,m2,m1,numTrials);
[stimAfname, trials2A] = makeEqual(nB,m1,m2,numTrials);
[stimBfname, trials2B] = makeEqual(nB,m2,m1,numTrials);
trials = shuffle([trials1A; trials1B; trials2A; trials2B]);

stimfilename = strcat('same_',num2str(m1),'_',num2str(m2),'.mat')
save(stimfilename,'trials');