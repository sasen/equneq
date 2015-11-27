function ltotrat = compare_computations()
% function ltotrat = compare_computations()
% ltotrat is estimated from the mean; it's not right!! FIXME
% tot(:,4) vs totval has empirical correct stuff, but I can't cluster it well.

load('../DATA/allStimuli123_6.mat');
nTr = length(mTr); % numTrials

totL = [mean2tot(sizes(:,1),6); mean2tot(sizes(:,1),12); mean2tot(sizes(:,1),6); ...
	mean2tot(sizes(:,1),12)];
totR = [mean2tot(sizes(:,2),6); mean2tot(sizes(:,2),12); mean2tot(sizes(:,2),12); ...
	mean2tot(sizes(:,2),6)];
totratio = (totL ./ totR);% + rand(size(totL))*0.01;
ltotrat = reshape(log2(totratio),nTicks,nTrialTypes);
tickVals = sizes(:,1) ./ sizes(:,2);

totTV = [-3:.25:3];  % FIXME: I don't know why this is the case
nTV = numel(totTV);
for tt = 1:nTr
  Lcirs = mTr(tt).Lcirs(:,3)';
  Rcirs = mTr(tt).Rcirs(:,3)';
  tot(tt,1) = totOfSet(Lcirs);
  tot(tt,2) = totOfSet(Rcirs);
  tot(tt,3) = tot(tt,1) / tot(tt,2);
  tot(tt,4) = mTr(tt).Lmean / mTr(tt).Rmean;  
end
totval = log2(tot(:,3));

totBin = nan(nTr,1);
% make tick values (log ratios) for psy function
for tk = 1:nTV
  tIdx = find(abs(totval - totTV(tk)) < 0.125);
  totBin(tIdx) = tk;
end

%figure(); plot(abs(totval),'x')

plotraw = 1;   %%%%%%% control whether to add empirical total area or not
figure(); hold on
ccols = 'bgrm';
cmarks = 'v^oo';
for cc = 1:4
  plot(log2(tickVals),ltotrat(:,cc),[ ccols(cc) cmarks(cc)],'MarkerSize',11,'LineWidth',2); 
end
legstr = {'6 & 6','12 & 12','6 & 12','12 & 6'};
if plotraw
  plot(log2(tot(:,4)),totval,'kx','LineWidth',2,'MarkerSize',14)
  legstr{end+1} = 'raw';
end
set(gca, 'FontSize', 20), axis tight, grid on
legend(legstr,'Location','NorthWest')
title('Strategies: Averaging vs. Accumulation')
xlabel('log-ratio MEAN Diam')
ylabel('log-ratio TOTAL Area ')
plot([-1; 1], [0 0],'k-','LineWidth',2)

% for tk = 1:17
%   for cc = 5:8
%     tots = totval(curvTrials{tk,cc});
%     assert(var(tots) < eps)
%     newTicks(tk,cc) = mean(tots);
%   end
% end