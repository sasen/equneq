function [stimfilename, trials] = makeDiff(m1,m2)
%function stimfilename = makeDiff(m1,m2)
%  m1, m2 (pos real): means 1 and 2 for the sets.
%  stimfilename (string): .mat filename to load in main experiment
%  trials (struct array): trialTypes 3 and 4 of m1/m2 and m2/m1
nA = 6; nB = 12;
[stimAfname, trialsA] = makeUnequal(nA,nB,m1,m2);
[stimBfname, trialsB] = makeUnequal(nA,nB,m2,m1);
trials = shuffle([trialsA; trialsB]);

stimfilename = strcat('diff_',num2str(m1),'_',num2str(m2),'.mat')
save(stimfilename,'trials');