clear all; close all;
load('../analysis/allSubjsFitarrays.mat')
ltotrot = compare_computation;
for sid = 1:length(subjList)
  subj = subjList(sid,:);
  [~,~,afcs] = aggregatePsy(subj);
  figure(sid);
  plotPsy(subj,afcs,tickVal,ms(sid,:),ss(sid,:));
  saveas(gcf,['../analysis/work/', subj,'_FitPsyPlots.jpg'],'jpg');
  figure(sid*10);
  plotPsy(subj,afcs,ltotrot,ms(sid,:),ss(sid,:));
  saveas(gcf,['../analysis/work/', subj,'_FitPsyPlots.jpg'],'jpg');

end

