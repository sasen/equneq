function [mOS, plotst, condst] = testUnequal(m3,m4,mEq)
% function [mOS, stats] = testUnequal(m3,m4,mEq)
% Testing if unequal conds are diff from mEq; overall shift of 'mOS'
% m3 = fit m params for each subj's 6v12 (mixed or blocked)
% m4 = fit m params for each subj's 12v6 (mixed or blocked)
% mOS = diffing m params for each subj --> "Overall Shift"
% plotst = yay t tests (for plotting)
% condst = crazier t tests (diff from mEq, overall shift, etc)
mOS = m3-m4;
[~,p(1),ci(:,1),stats1] = ttest(m3,mEq,[],'right');
[~,p(2),ci(:,2),stats2] = ttest(m4,mEq,[],'left');
[~,p(3),ci(:,3),stats3] = ttest(m3-mEq,mEq-m4,[],'both');
[~,p(4),ci(:,4),stats4] = ttest(mOS,0,[],'both');  % Ensem == Mean Diam? Note: MHT correction ~ alpha/2
[~,p(5),ci(:,5),stats5] = ttest(mOS,1,[],'both');  % Ensem == Total Area? Note: MHT correction ~ alpha/2
condst = catStruct(stats1,stats2);
condst = catStruct(condst,stats3);
condst = catStruct(condst,stats4);
condst = catStruct(condst,stats5);
condst.p = p;
condst.ci = ci;
condst.meanm = mean(ci);

[~,p,ci,plotst] = ttest([m3,m4],[],[],'both');
plotst.p = p;
plotst.ci = ci;
plotst.meanm = [mean(m3) mean(m4)];
