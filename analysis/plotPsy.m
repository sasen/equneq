function plotPsy(subj,psydata,ticks,ms,ss)
% function plotPsy(subj,psydata,ticks,ms,ss)
curvecolors = 'bgrmbgrm';

p.g=0; p.l=0;
curveRep = [1:4, 1:4];
nCurves = size(psydata,2);
for cur = 1:nCurves
  if numel(ticks)*2 == numel(psydata) %% plotting TOTAL, not mean
    tickVal = ticks(:,curveRep(cur))
    axisbounds = [-3 3 0 1];
  else  %% plotting MEAN, not total
    tickVal = ticks;
    axisbounds = [-1 1 0 1];
  end

  p.x = linspace(min(tickVal),max(tickVal));
  data = psydata(:,cur);
  p.m = ms(cur);
  p.s = ss(cur);
  pred = model(p);

  col = curvecolors(cur);
  subplot(2,1,ceil(cur/4)); hold on % top/bottom plot
  plot(tickVal, data, [col 'v'],'MarkerFaceColor',col,'MarkerSize',8)
  plot(p.x, pred, col,'LineWidth',2)
  plot(p.m,0.5, [col 'o'],'MarkerSize',12)

%   figure(1) %%% individual curve plots (debugging)
%   subplot(2,4,cur); hold on;
%   plot(tickVal, data, '^:')
%   plot(p.x, pred)
%   axis(axisbounds); grid on
end
subplot(211), axis(axisbounds);
set(gca, 'FontSize', 18), grid on
title([subj,': Blocked Conditions']); ylabel('Prop. Chose Left') 
%legend('6 vs 6','12 vs 12','6 vs 12','12 vs 6','Location','SouthEast') % FIXME
subplot(212), axis(axisbounds);
set(gca, 'FontSize', 18), grid on
title([subj, ': Mixed Condition']); xlabel('log_2 (\mu_L/\mu_R)'); ylabel('Prop. Chose Left')
