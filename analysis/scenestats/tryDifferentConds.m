stat = 'pixelStats';

stimfname = 'allStimuli123_6.mat';  % if not on path, it's in equneq/
load(stimfname,'sizes','sTr','dTr'); % some trials and parameters
ratios = sizes(:,1)./sizes(:,2);
psyAxis = log2(ratios);
nTicks = numel(psyAxis);

conds = {'6vs6', '12vs12', '6vs12', '12vs6'};
nConds = numel(conds);
figure();
for cnum = 1:nConds
  condString = conds{cnum};
  conddat{cnum} = load(['textureStats_1pool_' condString '.mat']);
  [tt{cnum}, tresults{cnum}, statL{cnum}, statR{cnum}] = compareStats(conddat{cnum}.tsL, conddat{cnum}.tsR, stat);
  subplot(nConds, 1, cnum), plot(psyAxis, abs(tt{cnum}),'o-'), title(condString)
  set(gca, 'FontSize',14), ylabel('|t_{value}|')
  hold on, ylim([0 10])
  plot(psyAxis, 2.2*ones(nTicks,1),'k:'), 
  plot(psyAxis, 3.1*ones(nTicks,1),'k--'), 
end  % for cond num
xlabel('log_2  (mean ratio)')
subplot(nConds,1,1), legend('mean','var','skew','kurt', 'Location','NorthOutside','Orientation','Horizontal')
suptitle('Paired t-test (df=11) for each Pixel Statistic')
tt, tresults, statL, statR
