function [stimfilename, trials] = makeSame(m1,m2,numPairs)
%function stimfilename = makeSame(m1,m2,numPairs)
% makeSame  make equal trials for both n=6 and n=12
%  m1, m2 (pos real): means 1 and 2 for the sets.
%  numPairs (pos int): how many distinct sets to make (will be doubled, per side)
%  stimfilename (string): .mat filename to load in main experiment
%  trials (struct array): trialTypes 3 and 4 of m1/m2 and m2/m1
nA = 6; nB = 12;

% generate tick of m1/m2
[stimAfname, trials1A] = makeEqual(nA,m1,m2,numPairs);  % trialType 1
[stimAfname, trials2A] = makeEqual(nB,m1,m2,numPairs);  % trialType 2

if m1 ~= m2  % generate other tick of m2/m1
  [stimBfname, trials1B] = makeEqual(nA,m2,m1,numPairs);
  [stimBfname, trials2B] = makeEqual(nB,m2,m1,numPairs);
  trials = shuffle([trials1A; trials1B; trials2A; trials2B]);
else   % if means equal, then m1/m2 == m2/m1, so can't make the other tick
  trials = shuffle([trials1A; trials2A]); 
end
stimfilename = strcat('same_',num2str(m1),'_',num2str(m2),'.mat')
save(stimfilename,'trials');