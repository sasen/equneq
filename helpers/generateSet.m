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

%% is this stuff even necessary? FIXME
dev = 1.5*sqrt(rvar);
rmin = rmean-dev; rmax = rmean + dev;  %% U[rmin, rmax]
assert(rmin > minSize,'Cannot go that small.')
assert(rmax < maxSize,'Cannot go that big.')
candidateRs = rmin + (rmax - rmin).*rand(numCands,numItems); %% unif samples

for ss = 1:numCands
  zrad = zscore(candidateRs(ss,:));              % zscore them
  setmat(ss,:) = zrad*sqrt(rvar) + rmean;   % scale to proper mean and variance
end

save(strcat('six',num2str(rmean),'.mat'),'setmat');
