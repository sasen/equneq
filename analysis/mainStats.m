function mainStats(sType,withbox)
% function mainStats(sType,withbox)
% Controls evaluation of statistics test (fits must be done!)
% sType = 'group' or 'indiv'
% withbox = 0 or 1, draws boxplot (optional, default 0==no)
if nargin == 1
  withbox = 0;
end

f = load('../analysis/allSubjsFitarrays.mat'); % fit struct
% several sets of analysis to do:
%----- group 001--005 + ssc
% BLOCKED, MIXED, BK v MX
%----- indiv stability
% BLOCKED, MIXED, BK v MX
%---- sigma comparisons
%---- bizarre shifty thing??
groupSID = [1,2,3,4,5,6];
indivSID = [6,7,8];
SID = struct('group',groupSID,'indiv',indivSID);
ANLYZ = SID.(sType);
f.ECUR = [1 2; 5 6];  % top row is blocked (cond 1), bot row is mixed (cond 2)
f.UCUR = [3 4; 7 8];

if withbox == 1
  boxplot(f.ms(ANLYZ,:)), hold on; %,'plotstyle','compact'); hold on
else
  figure(); hold on
end

for COND = [1 2];  % 1 = blocked, 2 = mixed
  [mEq(:,COND),est(COND),moreEst(COND)] = calltestEqual(f,COND,ANLYZ);
  [mOS(:,COND),ust(COND),moreUst(COND)] = calltestUnequal(f,COND,ANLYZ,mEq(:,COND));
  myst(COND) = catStruct(est(COND),ust(COND));
  mysigst(COND) = testSigmas(f,COND,ANLYZ);
end
condst = testConds(mEq,mOS);

st = catStruct(myst(1),myst(2));
sigst = catStruct(mysigst(1),mysigst(2));
assignin('base','sigst',sigst)
moreU = catStruct(moreUst(1),moreUst(2));
moreE = catStruct(moreEst(1),moreEst(2));
printStats(st)
printStats(moreE)
printStats(moreU)
printStats(condst)
printStats(sigst)

plot(st.conds,st.meanm,'go','MarkerSize',14); %bar(st.conds,st.meanm);
samepaints = [f.ECUR'; f.UCUR'];
curvecolors = 'bgrm';
for cur = 1:4
  these = samepaints(cur,:);
  col = curvecolors(cur);
  plot(st.conds(these),st.meanm(these),[col '.'],'MarkerSize',45);
end
xrange = [0.5 8.5]';
xlim(xrange);
lh4 = line(xrange,[0;0]);
set(lh4,'Color','k','LineStyle','-','LineWidth',1);

errorbar(st.conds,st.meanm,range(st.ci)/2,'LineStyle','none','Color','k')
set(gca, 'FontSize', 18)
yrange = get(gca,'YLim');
lh = line([4.5; 4.5],yrange');
set(lh,'Color','k','LineWidth',3);
lh2 = line([2.5; 2.5],yrange');
set(lh2,'Color','k','LineWidth',1,'LineStyle',':');
lh3 = line([6.5; 6.5],yrange');
set(lh3,'Color','k','LineWidth',1,'LineStyle',':');
ylabel('mean PSE')
title([sType ': Mu Fits'])
condnames = {'  6/6 B','12/12 B',' 6/12 B',' 12/6 B','  6/6 M','12/12 M',' 6/12 M',' 12/6 M'};
xticklabel_rotate([1:8],45,condnames,'Fontsize',18);
saveas(gcf,['../analysis/work/', sType,'_muPlots.jpg'],'jpg')

figure()
plot(f.ss(ANLYZ,:)','+--','LineWidth',2); hold on
legend([f.subjList(ANLYZ,:)],'Location','Best')
set(gca, 'FontSize', 18)
title([sType ': Sigma Fits'])
ylabel('Slope')
xticklabel_rotate([1:8],45,condnames,'Fontsize',18);
axis tight
yrange = get(gca,'YLim');
boxplot(f.ss(ANLYZ,:));
axis([0.5 8.5 yrange])
saveas(gcf,['../analysis/work/', sType,'_sigmaPlots.jpg'],'jpg')