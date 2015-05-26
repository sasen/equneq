function [mEq, stats, condstats] = testEqual(m6,m12)
% function [mEq, stats] = testEqual(m6,m12)
% Testing if equal conditions are diff from 0 or e.o.; avging to 'mEq'
% m6 = fit m params for each subj's 6v6 (mixed or blocked)
% m12 = fit m params for each subj's 12v12 (mixed or blocked)
% mEq = averaging m params for each subj --> "Equal trials"
% stats = yay t tests (for plotting)
% condstats = stats for this condition (diff from each other, mEq)

[~,p,ci,stats] = ttest([m6,m12],[],[],'both');
stats.p = p;
stats.ci = ci;
stats.meanm = [mean(m6) mean(m12)];
mEq = mean([m6,m12],2);

[~,p,ci,condstats] = ttest(m6,m12,[],'both');
condstats.p = p;
condstats.ci = ci;

[~,p,ci,st] = ttest(mEq,[],[],'both');
st.p = p;
st.ci = ci;
condstats = catStruct(condstats,st);
