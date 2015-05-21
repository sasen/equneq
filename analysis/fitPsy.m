close all
psydata = plotPsy('ssc',123,6);
load('../analysis/saved.mat')

counts = 12*ones(size(psydata));  %%%% FIXME: get from dataset! no lies!
shape = 'cumulative Gaussian';
curvecolors = 'bgrcbgrc';
%prefs = batch('shape', shape, 'n_intervals', 2, 'fix_gamma', NaN,'runs',500);
prefs = batch('shape', shape, 'n_intervals', 2, 'fix_gamma', NaN, 'fix_lambda', NaN, 'runs',500);

%%% one at a time
% mycurve = [log2(tickVal)' psydata(:,1) counts(:,1)];
% outputPrefs = batch('write_pa', 'ssc_params1');
% psignifit(mycurve, [prefs outputPrefs]);

fitarray = zeros(nCurves,4);
for cur = 1:nCurves
  mycurve = [log2(tickVal)' psydata(:,cur) counts(:,cur)];
%  outputPrefs(cur,:) = batch('write_pa', ['ssc_params',num2str(cur)] );
%  psignifit(mycurve, [prefs outputPrefs(cur,:)]);  
  if ~any(fitarray(cur,:))
    fits(cur) = pfit(mycurve, 'no plot', 'compute_stats',0, prefs);
    fitarray(cur,:) = fits(cur).params.est;
  end
%  eval(['myparams = ' outputPrefs(cur,end-11:end-1),'.est']);

  %%% individual curve plots (useful for debugging)
  figure(3); subplot(2,4,cur); hold on
  plotpd(mycurve,...
	 'Marker','s',...
	 'MarkerFaceColor', curvecolors(cur),...
	 'MarkerEdgeColor','k',...
	 'MarkerSize',14);
  plotpf(shape, fits(cur).params.est,...
	 'LineStyle','-',... %linestyles{s},...
	 'Color', curvecolors(cur),...
	 'LineWidth',2');

  figure(1); subplot(2,1,ceil(cur/4)); hold on % top/bottom plot
  plotpf(shape, fitarray(cur,:),...
	 'LineStyle','-',... %linestyles{s},...
	 'Color', curvecolors(cur),...
	 'LineWidth',2');

end