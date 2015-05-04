function setmat = generateSet(numItems, rmean)
% At the moment, this tries to generate a ton of such sets, 
% LIES------
%function setmat = generateSet(numItems, rmean, rvar, hullrect)
%numItems=6; rmean=55; 
rvar=576; hullrect = [0 0 320 400];  %% SS FIXME: pass in from main
% function setmat = generateSet(numItems, rmean, rvar, hullrect)
% generateSet  Generates parameters for an ensemble of circles
%   numItems (pos integer): number of items (circles) in the set
%   rmean (pos real): average radius of the circles, in pixels
%   rvar (pos real): variance of the radiuses, in square-pixels
%   hullrect (1x4 pos real): rect region circles fit into, [xmin ymin xmax ymax]
%   setmat (numItems x 3 pos real): in pixels 
%      col 1 & 2: x & y positions of circle centers, col 3: radius of each circle
% Note: Avoids overlapping (maybe add a min-spacing parameter?)
% Note: Not intended to be run in realtime, i.e., during an experiment.

% some hard limits
minSize = 15; maxSize = 150;  %% SS FIXME: these shouldn't hide here! pass in from main expt
numCands = 100; % number of candidates to generate
meantol_rough = 5; vartol_rough = 1000;

% need to account for radius!!
xdist = hullrect(3)-hullrect(1);  % horizontal span
ydist = hullrect(4)-hullrect(2);  % vertical span
xyarea = xdist * ydist;  % total footprint we have to work with
meanA = xyarea/numItems; % roughly divvy that up amongst the circles
areamean = pi*rmean^2;
areatot = numItems * areamean;
%assert(xyarea > areatot,'Too much circle for one rectangular hull!')  %% Make sure this is even possible!

candidateRs = minSize + (maxSize - minSize).*rand(numCands,numItems); %% unif samples

setmat = [];
for ss = 1:numCands
  rescaled = zscore(candidateRs(ss,:))*sqrt(rvar) + rmean;  % zscore them & rescale to proper mean & var
  % only save if all items are within the acceptable range
  if (min(rescaled) > minSize) & (max(rescaled) < maxSize)
    setmat(end+1,:) = rescaled;
  end
end

%% FIXME
%%% it would be nice to be able to ask for, say, 100 sets, and keep doing this until we get that many.
%% or I can just do that by hand, whatever.