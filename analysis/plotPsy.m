function [afcmat,accmat, mRTmat, curvTrials] = plotPsy(subjCode,mStandard,nPairs)
% function [afcmat,accmat, mRTmat, curvTrials] = plotPsy(subjCode,mStandard,nPairs)
% eg [afc,acc,~,~] = plotPsy('s17',128,1)

switch nargin
 case 0
  error('%s Give at least the subject code.',mfilename)
 case 1
  mStandard = 128;
  nPairs = 7;
end

stimFname = strcat('allStimuli',num2str(mStandard),'_',num2str(nPairs),'.mat');
load(stimFname); % all trials and parameters
dirname = strcat(['../DATA/het',subjCode,'/']);
sDir = what(dirname);
fnames = sDir.mat;

curvTrials = cell(nTicks,nCurves);  % store trial numbers of each tick by curve type
accmat = nan(nTicks,nCurves);  % [0,1] accuracy data over psy ticks
afcmat = nan(nTicks,nCurves);  % [0,1] chose left in 2AFC <--- psy func data!
mRTmat = nan(nTicks,nCurves);  % mean RT data over psy ticks
% would be good to record std and number of trials responded to (with l or r)

for cond = 1:length(fnames) 
datafile = strcat([dirname, fnames{cond,:}]);
load(datafile,'expdata');
fprintf(1,'%s had accuracy %0.3f.\n',fnames{cond,:},nanmean(expdata.ACCs))  % what's accuracy like?

cType = expdata.trialType; % get curveType for each trial
nTr = length(cType);  % number of trials in datafile
types = sort(unique(cType));  % which trialTypes are present here
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
  curv = types(i);
  for tk = 1:nTicks
    trList = find(cType==curv & tickNums'==tk);
    curvTrials{tk,curv} = trList;  % list of trials belonging to this tick
    %% wait: what should happen if subj hit wrong button or didn't respond? maybe not nanmean
    accmat(tk,curv) = nanmean(expdata.ACCs(trList));  % accuracy at this tick
    mRTmat(tk,curv) = nanmean(expdata.RTs(trList));  % RTs... needs more processing FIXME
    afcmat(tk,curv) = nanmean(expdata.afcL(trList));  % fraction chose left at this tick
  end
end
end  % for each cond (go through data files)
%curvTrials can be aggregated by block as a 3rd cell dimension

subplot(211), plot(log2(tickVal),afcmat(:,1:4),'o-'), axis tight 
title([subjCode,': Same or Different']); xlabel('log2 (Lmean/Rmean)'); ylabel('% Chose Left')
legend('6 vs 6','12 vs 12','6 vs 12','12 vs 6')
subplot(212), plot(log2(tickVal),afcmat(:,5:8),'o-'), axis tight
title([subjCode, ': Mixed Condition']); xlabel('log2 (Lmean/Rmean)'); ylabel('% Chose Left')

save('../analysis/saved.mat')