clear all; close all;

subjList = ['001';'002';'003';'004';'005';'ssc'; '101';'102';'103';'104';'105';'106';'107';'108';'109';'110';'111';'112'];  % ['s2h';'s22'];
for sid = 1:length(subjList)
  subj = subjList(sid,:);
  load(['../analysis/work/',subj,'_rawPsy.mat']);  %  [tick_dratio,counts,afcs] = aggregatePsy(subj);
  allafcs(:,sid) = afcmat(:);
end 

meanafcs = reshape(mean(allafcs,2),nTicks,nCurves)
tickVallog = log2(tickVal);
counts = nTrialsPerTick*ones(nTicks,nCurves);
[mean_m, mean_s] = fitPsy(tickVallog,counts,meanafcs);
plotPsy('Mean',meanafcs,tickVallog,mean_m,mean_s);
saveas(gcf,['../analysis/work/nice_figs/mean_FitPsyPlots.png'],'png');
save('../analysis/meanFit.mat')
