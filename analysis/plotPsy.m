function subPsy_figh = plotPsy(subjCode,afcmat,tickVal)
% function [tickVals,cntmat, afcmat,accmat, mRTmat, curvTrials] = plotPsy(subjCode,mStandard,nPairs)
% eg [ticks,ns,afc,acc] = plotPsy('s17',123,6)

xaxis = log2(tickVal);

subPsy_figh = clf('reset');
subplot(211)
plot(xaxis,afcmat(:,1),'bs','MarkerSize',9), hold on
plot(xaxis,afcmat(:,2),'gs','MarkerSize',9),
plot(xaxis,afcmat(:,3),'rd','MarkerSize',9),
plot(xaxis,afcmat(:,4),'md','MarkerSize',9), axis tight 
set(gca, 'FontSize', 18), grid on
title([subjCode,': Blocked Conditions']); ylabel('Prop. Chose Left') 
legend('6 vs 6','12 vs 12','6 vs 12','12 vs 6','Location','SouthEast')
subplot(212),
plot(xaxis,afcmat(:,5),'bo','MarkerSize',9), hold on
plot(xaxis,afcmat(:,6),'go','MarkerSize',9), 
plot(xaxis,afcmat(:,7),'ro','MarkerSize',9), 
plot(xaxis,afcmat(:,8),'mo','MarkerSize',9), axis tight
set(gca, 'FontSize', 18), grid on
title([subjCode, ': Mixed Condition']); xlabel('log2 (Lmean/Rmean)'); ylabel('Prop. Chose Left')
