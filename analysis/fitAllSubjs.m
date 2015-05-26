clear all; close all;

subjList = ['001';'002';'003';'004';'005';'ssc';'s2h';'s22'];
for sid = 1:length(subjList)
  subj = subjList(sid,:);
  [tick_dratio,counts,afcs] = aggregatePsy(subj);
  tickVal = log2(tick_dratio);

  [ms(sid,:), ss(sid,:)] = fitPsy(tickVal,counts,afcs);
  figure(sid)
  plotPsy(subj,afcs,tickVal,ms(sid,:),ss(sid,:));
end
save('../analysis/allSubjsFitarrays.mat')
