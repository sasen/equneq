function fitarray = fitPsy(subj,fitarray)
[counts, psydata] = plotPsy(subj);
load('../analysis/saved.mat')  % getting nCurves, tickVal

shape = 'cumulative Gaussian';
curvecolors = 'bgrmbgrm';
prefs = batch('shape', shape, 'n_intervals', 2, 'fix_gamma', NaN, 'fix_lambda', NaN);  % 'runs',500

%%% one at a time
% mycurve = [log2(tickVal)' psydata(:,1) counts(:,1)];
% outputPrefs = batch('write_pa', 'ssc_params1');
% psignifit(mycurve, [prefs outputPrefs]);

%% giving a partial fitarray as input allows us to retry when psignifit segfaults
%% if no partial fitarray is supplied, fit every curve from scratch.
if nargin == 1
  fitarray = zeros(nCurves,4);
end

for cur = 1:nCurves
  assignin('base','partialFitArray',fitarray);
  mycurve = [log2(tickVal)' psydata(:,cur) counts(:,cur)];
%  outputPrefs(cur,:) = batch('write_pa', ['ssc_params',num2str(cur)] );
%  psignifit(mycurve, [prefs outputPrefs(cur,:)]);  
  if ~any(fitarray(cur,:))
    fits(cur) = pfit(mycurve, 'no plot', 'compute_stats',0, prefs);
    fitarray(cur,:) = fits(cur).params.est;
  end
%  eval(['myparams = ' outputPrefs(cur,end-11:end-1),'.est']);

%   %%% individual curve plots (useful for debugging)
%   figure(3); subplot(2,4,cur); hold on
%   plotpd(mycurve,...
% 	 'Marker','s',...
% 	 'MarkerFaceColor', curvecolors(cur),...
% 	 'MarkerEdgeColor','k',...
% 	 'MarkerSize',14);
%   plotpf(shape, fitarray(cur,:),...
% 	 'LineStyle','-',... %linestyles{s},...
% 	 'Color', curvecolors(cur),...
% 	 'LineWidth',2');


  subplot(2,1,ceil(cur/4)); hold on % top/bottom plot
  plotpf(shape, fitarray(cur,:),...
	 'LineStyle','-',... %linestyles{s},...
	 'Color', curvecolors(cur),...
	 'LineWidth',2');

end

save(['../analysis/curves',subj,'.mat'])