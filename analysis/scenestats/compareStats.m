function [tt, tresults, statL, statR] = compareStats(tsL,tsR, stat)
% [tt, tresults, statL, statR] = compareStats(tsL,tsR, stat)
% gets the stat and returns tvalues from paired ttest of each stat to compare, and each psychometric function tick
%   tsL and tsR, texture statistics organized by psyTick
%   stat (string) must be field of the struct returned by Portilla & Simoncelli texureAnalysis()
%   tt: just tvalues. columns = different stats, rows = psyTick
%   tresults: struct array, whole ttest (.h, .p, .ci, .s)
%   statL, statR: cell arrays containing the stats being compared

for tick = 1:numel(tsL)
  for tr = 1:numel(tsL{tick})
    statL{tick}(tr,:) = tsL{tick}{tr}.(stat);
    statR{tick}(tr,:) = tsR{tick}{tr}.(stat);
  end  % for tr of this tick
  [test.h,test.p,test.ci,test.s] = ttest(statL{tick}, statR{tick});
  tresults(tick) = test;
  tt(tick,:) = test.s.tstat;
end % for tick

