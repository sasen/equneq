function lums = generateLuminances(trials);
% Generate uniformly drawn luminance for each circle in a block.
% function lums = generateLuminances(trials);
%   trials (struct array): each element contains all info for a trial. (except luminance!)
%   lums (struct array): each element contains the luminance info for the corresponding trials trial
% HACK TODO FIXME: pick random luminances, just to see what it looks like

numTrials = numel(trials);
trField = cell(numTrials,1);
lums = struct('Lcirs',trField, 'Rcirs',trField);

for i = 1:numTrials
  numL = size(trials(i).Lcirs,1);
  lums(i).Lcirs = 255*rand(1,numL);
  numR = size(trials(i).Rcirs,1);
  lums(i).Rcirs = 255*rand(1,numR);
end % for trials