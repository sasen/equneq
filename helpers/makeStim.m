function [stimfilename, sTr, dTr, mTr] = makeStim(m1,m2,numPairs)
% function [stimfilename, sTr, dTr, mTr] = makeStim(m1,m2,numPairs)
% makeStim  make Same, Diff, and Mixed trials for 2 ratios: m1/m2 and m2/m1
%  m1, m2 (pos real): means 1 and 2 for the sets.
%  numPairs (pos int): how many distinct sets to make (will be doubled, per side)
%  stimfilename (string): .mat filename to load in main experiment
%  sTr,dTr,mTr (struct array): same/diff/mixed trials for  m1/m2 and m2/m1
[samefname, sTr] = makeSame(m1,m2,numPairs);
[difffname, dTr] = makeDiff(m1,m2,numPairs);
mTr = shuffle([sTr; dTr]);  % Mix grabs Same and Diff trials and reuses them

stimfilename = strcat('all_',num2str(m1),'_',num2str(m2),'.mat')
save(stimfilename,'sTr','dTr','mTr');