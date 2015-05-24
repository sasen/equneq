function [cntmat, afcmat,accmat, mRTmat, curvTrials] = plotPsy(subjCode,mStandard,nPairs)
% function [cntmat, afcmat,accmat, mRTmat, curvTrials] = plotPsy(subjCode,mStandard,nPairs)
% eg [afc,acc,~,~] = plotPsy('s17',128,1)

switch nargin
 case 0
  error('%s Give at least the subject code.',mfilename)
 case 1
  mStandard = 123;
  nPairs = 6;
end

stimFname = strcat('allStimuli',num2str(mStandard),'_',num2str(nPairs),'.mat');
load(stimFname); % all trials and parameters
dirname = strcat(['../DATA/het',subjCode,'/']);
sDir = what(dirname);
fnames = sDir.mat;

%%% Initialize Outputs
% would be good to record var/sd/se
curvTrials = cell(nTicks,nCurves);  % store trial numbers of each tick by curve type
accmat = nan(nTicks,nCurves);  % [0,1] accuracy data over psy ticks
afcmat = nan(nTicks,nCurves);  % [0,1] chose left in 2AFC <--- psy func data!
mRTmat = nan(nTicks,nCurves);  % mean RT data over psy ticks
cntmat = nan(nTicks,nCurves);  % counts, ie # of trials responded to (with l or r)
pattern_for_invalid_responses = '[^hk]'; % regular expression to find choices that aren't h (l) or k (r)

for cond = 1:length(fnames) 
datafile = strcat([dirname, fnames{cond,:}]);
load(datafile,'expdata');
fprintf(1,'%s had accuracy approx %0.3f.\n',fnames{cond,:},nanmean(expdata.ACCs))  % what's accuracy like?

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
    trList = find(cType==curv & tickNums'==tk); % list of trials belonging to this tick
    curvTrials{tk,curv} = trList;
    %% wait: what should happen if subj hit wrong button or didn't respond? maybe not nanmean
    % look at choices, get # responded either l or r. we'll divide by that.
    invalid_trNums = regexp([expdata.choices{trList},'h'], pattern_for_invalid_responses);
    numValid        = (nPairs*2) - numel(invalid_trNums);  % counts of L or R responses (not invalid key / late)
    cntmat(tk,curv) = numValid;
    accmat(tk,curv) = nansum(expdata.ACCs(trList)) / numValid;  % accuracy at this tick
    mRTmat(tk,curv) = nanmean(expdata.RTs(trList));  % RTs... needs more processing FIXME
    afcmat(tk,curv) = nansum(expdata.afcL(trList)) / numValid;  % fraction chose left at this tick
  end
end
end  % for each cond (go through data files)
%curvTrials can be aggregated by block as a 3rd cell dimension

subplot(211), hold off
plot(log2(tickVal),afcmat(:,1),'bs--','MarkerSize',9), hold on
plot(log2(tickVal),afcmat(:,2),'gs--','MarkerSize',9),
plot(log2(tickVal),afcmat(:,3),'rd--','MarkerSize',9),
plot(log2(tickVal),afcmat(:,4),'md--','MarkerSize',9), axis tight 
set(gca, 'FontSize', 18), grid on
title([subjCode,': Same or Different']); ylabel('Prop. Chose Left')  % xlabel('log2 (Lmean/Rmean)'); 
legend('6 vs 6','12 vs 12','6 vs 12','12 vs 6','Location','SouthEast')
subplot(212), hold off
plot(log2(tickVal),afcmat(:,5),'bo--','MarkerSize',9), hold on
plot(log2(tickVal),afcmat(:,6),'go--','MarkerSize',9), 
plot(log2(tickVal),afcmat(:,7),'ro--','MarkerSize',9), 
plot(log2(tickVal),afcmat(:,8),'mo--','MarkerSize',9), axis tight
set(gca, 'FontSize', 18), grid on
title([subjCode, ': Mixed Condition']); xlabel('log2 (Lmean/Rmean)'); ylabel('Prop. Chose Left')


save('../analysis/saved.mat')