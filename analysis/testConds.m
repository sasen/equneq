function condst = testConds(mEq,mOS)
% function condst = testConds(mEq,mOS)
% Do the conditions Blocked vs Mixed differ on EQ vs UNEQ overall measures?

X = [mEq(:,1) mOS(:,1)];
Y = [mEq(:,2) mOS(:,2)];
[~,p,ci,condst] = ttest(X,Y,[],'both');  % do conds (block vs mix) differ?
condst.p = p; 
condst.ci = ci;
