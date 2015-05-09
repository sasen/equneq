function setmat = generateSet(numItems, rmean, numSets)
% function setmat = generateSet(numItems, rmean, numSets)
% generateSet  Generate radii of ensembles of circles, with fixed mean & var
%   numItems (pos int): number of items (circles) in the set
%   rmean (pos real): average radius of the circles, in pixels
%   numSets (pos int): number of sets to generate (eg 20)
%   setmat (numItems x numSets pos real): radius of each circle (px)
% Note: Not intended to be run in realtime, i.e., during an experiment.
rvar=576; %% SS FIXME: pass in from main
minSize = 15; maxSize = 150;  %% SS FIXME: these shouldn't hide here! pass in from main expt

% we'll need to draw samples until we get enough that meet the size constraints
setmat = [];
while size(setmat,1) < numSets  %% do until we have more than enough sets
  % draw samples from uniform distribution over [minSize, maxSize]
  candidateRs = minSize + (maxSize - minSize).*rand(numSets,numItems); 

  for ss = 1:numSets   %% rescale by zscore, remove sets with too-big or too-small items
    rescaled = zscore(candidateRs(ss,:))*sqrt(rvar) + rmean;  % zscore them & rescale to proper mean & var
    %% only save if all items are within the acceptable range
    if (min(rescaled) > minSize) & (max(rescaled) < maxSize)
      setmat(end+1,:) = rescaled;
    end
  end % for sets we just drew
end  % while not enough sets

% trim down to requested number
setmat = setmat(1:numSets,:);