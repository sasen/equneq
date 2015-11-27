load('../analysis/curvesssc.mat')

shape = 'cumulative Gaussian';
curvecolors = 'bgrmbgrm';
%prefs = batch('shape', shape, 'n_intervals', 2, 'fix_gamma', NaN, 'fix_lambda', NaN);  % 'runs',500

fakeFA = [fitarray(1:4,:); fitarray(1:4,:)]; 
subplot(211),plot(), xlim(minmax(log2(tickVal)))
subplot(212),xlim(minmax(log2(tickVal)))
for cur = 1:nCurves
%   assignin('base','partialFitArray',fitarray);
%   mycurve = [log2(tickVal)' psydata(:,cur) counts(:,cur)];
%   if ~any(fitarray(cur,:))
%     fits(cur) = pfit(mycurve, 'no plot', 'compute_stats',0, prefs);
%     fitarray(cur,:) = fits(cur).params.est;
%   end

  subplot(2,1,ceil(cur/4)); hold on % top/bottom plot
  plotpf(shape, fakeFA(cur,:),...
	 'LineStyle','-',... %linestyles{s},...
	 'Color', curvecolors(cur),...
	 'LineWidth',2');
end


