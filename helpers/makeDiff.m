function [stimfilename, trials] = makeDiff(m1,m2,numPairs)
%function stimfilename = makeDiff(m1,m2,numPairs)
%  m1, m2 (pos real): means 1 and 2 for the sets.
%  numPairs (pos int): how many sets to make (will be doubled, per side)
%  stimfilename (string): .mat filename to load in main experiment
%  trials (struct array): trialTypes 3 and 4 of m1/m2 and m2/m1
nA = 6; nB = 12;

% generate both trialTypes (3 and 4) simultaneously, because they're just L/R flip
[stimAfname, trialsA] = makeUnequal(nA,nB,m1,m2,numPairs); % tick of m1/m2

if m1 ~= m2  % generate other tick of m2/m1
  [stimBfname, trialsB] = makeUnequal(nA,nB,m2,m1,numPairs);
  trials = shuffle([trialsA; trialsB]);
else   % if means equal, then m1/m2 == m2/m1, so can't make the other tick
  trials = shuffle([trialsA]);
end

stimfilename = strcat('diff_',num2str(m1),'_',num2str(m2),'.mat');
save(stimfilename,'trials');