clear all; close all;

subjList = ['101';'102';'103';'104';'105';'106';'107';'108';'109';'110'];  %['001';'002';'003';'004';'005';'ssc';'s2h';'s22'];
for sid = 1:length(subjList)
  subj = subjList(sid,:);
  [tick_dratio,counts,afcs] = aggregatePsy(subj);
  tickVal = log2(tick_dratio);

  [ms(sid,:), ss(sid,:)] = fitPsy(tickVal,counts,afcs);
  figure(sid)
  plotPsy(subj,afcs,tickVal,ms(sid,:),ss(sid,:));
  saveas(gcf,['../analysis/work/', subj,'_FitPsyPlots.jpg'],'jpg');
end
save('../analysis/allSubjsFitarrays.mat')
