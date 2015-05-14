function [stimfilename, sTr, dTr, mTr] = makeAll(mStandard,debug)
% function [stimfilename, sTr, dTr, mTr] = makeAll(mStandard,debug)
% makeAll  make Same, Diff, and Mixed trials for all ratios!
% mStandard: mean size in pixels of standard set (aim for 40 to 130)
% debug: makes just 1 unique pair each
%  stimfilename (string): .mat filename to load in main experiment
%  sTr,dTr,mTr (struct array): same/diff/mixed trials (full conditions!)

if debug
  nPairs = 1;
else
  nPairs = 7;
end
nTicks = 15;
paramFilename = psyPoints(mStandard,nPairs,nTicks,debug);
load(paramFilename);

halfTicks = (nTicks-1)/2;  % won't get ratio of 1 this way!! FIXME 
%nPerCall = nTrialsPerTick*2*2;  % (already 2x); 2 ticks/call; 2 trialTypes/cond
nPerCall = nPairs*8;  % 2x; 2 ticks/call; 2 trialTypes/cond
nTotal = halfTicks*nPerCall;

% initialize with m1==m2 (the 0 log-ratio) tick
m1 = sizes(halfTicks+1, 1); m2 = sizes(halfTicks+1, 2);
[~, sAll, dAll, mAll] = makeStim(m1,m2,nPairs);

% then call makeStim to fill out m1/m2 and m2/m1 ticks
for tick = 1:halfTicks
  m1 = sizes(tick,1);
  m2 = sizes(tick,2);
  [~, sTr, dTr, mTr ] = makeStim(m1,m2,nPairs);
  sAll(end+1:end+nPerCall) = sTr;
  dAll(end+1:end+nPerCall) = dTr;
  mAll(end+1:end+(2*nPerCall)) = mTr;
end

% now shuffle!
sTr = shuffle(sAll);
dTr = shuffle(dAll);
mTr = shuffle(mAll);
stimfilename = strcat('allStimuli','.mat')
save(stimfilename)
