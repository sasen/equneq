%function psymat = plotPsy(datafile)
fnames =  ...
['d0_888_time16_20_00.mat'; ...
 'm0_888_time16_29_45.mat'; ...
 's0_888_time16_36_58.mat'];

load('allStimuli.mat'); % all trials and parameters

curvTrials = cell(nTicks,nCurves);  % store trial numbers of each tick by curve type
accmat = nan(nTicks,nCurves);  % [0,1] accuracy data over psy ticks
afcmat = nan(nTicks,nCurves);  % [0,1] chose left in 2AFC <--- psy func data!
mRTmat = nan(nTicks,nCurves);  % mean RT data over psy ticks
% would be good to record std and number of trials responded to (with l or r)

for cond = 1:3 
datafile = strcat([ '../DATA/het888/', fnames(cond,:)])
load(datafile,'expdata');

cType = expdata.trialType; % get curveType for each trial
nTr = length(cType);  % number of trials in datafile
types = sort(unique(cType))  % which trialTypes are present here
if length(types) == 4
  cType = cType + 4;   % mixed blocks will have 5=6/6, 6=12/12, 7=6/12, 8=12/6
  types = types + 4;
end

ratios = expdata.Lmean./expdata.Rmean;  % ratio for each trial
tickNums = nan(nTr,1);
% make tick values (log ratios) for psy function
for tk = 1:nTicks
  tickVal(tk) = sizes(tk,1)/sizes(tk,2);  % left/right
  tIdx = find(abs(ratios - tickVal(tk)) < eps);
  tickNums(tIdx) = tk;
end

% data for each curve
for i = 1:length(types)
  curv = types(i)
  for tk = 1:nTicks
    trList = find(cType==curv & tickNums'==tk);
    curvTrials{tk,curv} = trList;  % list of trials belonging to this tick
    %% wait: what should happen if subj hit wrong button or didn't respond? maybe not nanmean
    accmat(tk,curv) = mean(expdata.ACCs(trList));  % accuracy at this tick
    mRTmat(tk,curv) = mean(expdata.RTs(trList));  % RTs... needs more processing FIXME
    afcmat(tk,curv) = mean(expdata.afcL(trList));  % fraction chose left at this tick
  end
end
end  % for each cond (go through data files)
%curvTrials can be aggregated by block as a 3rd cell dimension

subplot(211), plot(tickVal,mRTmat(:,1:4))
subplot(212), plot(tickVal,mRTmat(:,5:8))