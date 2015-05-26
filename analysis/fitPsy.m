function [mstar, sstar] = fitPsy(tickVal,counts,psydata)
% function [mstar, sstar] = fitPsy(tickVal,counts,psydata)
nCurves = size(counts,2); 
mstar = nan(nCurves,1); sstar = mstar;
for cur = 1:nCurves
  data = psydata(:,cur);
  [mstar(cur), sstar(cur), pstar] = fitMS(tickVal, data, counts(:,cur));
end
