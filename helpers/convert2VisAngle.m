function inDeg = convert2VisAngle(inPx)
% function inDeg = convert2VisAngle(inPx)
% convert2VisAngle  EXPERIMENT-SPECIFIC pixels -> degrees of visual angle
%  Needs correct measurements for viewing distance and screen width.
%  If no arguments, reports allowable range, SD, and mean sizes.
%    inPx (scalar/vector/matrix): quantity in pixels
%    inDeg ("): in degrees

ViewDist    = 60;    % measured fixation to my nose (cm), approximate
ScrWidth    = 28.5;  % measured across the top (cm)

ScrRes     = Screen('Resolution',0);   % get ScrRes.width ScrRes.height (pixels)

degPerHalfScreen = atan2d( (ScrWidth/2), ViewDist);  % degrees subtended by left/right half; sohcahTOA
degPerPx = degPerHalfScreen * (2 / ScrRes.width);   % degrees per pixel

%% this is the main body of this function
if nargin==1
  inDeg = degPerPx .* inPx;
  return
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% no inputs, so print useful stuff
load('params123_nPairs6.mat')  % get things to convert to visual angle

mean_diams = convert2VisAngle(unique(sizes)')

%% want distance to each dot location, in degrees. ok, grab locations of all 12 dots (fixed)
% make it relative to fixation location; subtract off y coord. (round down)
loc12 = fixedPositions(12) - repmat([0 ScrRes.height/2],12,1);
for loc = 1:12
  dists(loc) = norm(floor(loc12(loc,:)));
end
dists_from_fix = convert2VisAngle(unique(dists))
x_coordinates = convert2VisAngle(unique(loc12(:,1))')
y_coordinates = convert2VisAngle(unique(loc12(:,2))')

fprintf(1, 'Standard Size diam in degrees: %.2f\n', convert2VisAngle(mStandard) )

diam_sd = std(generateSet(12,mStandard,1));  % make a set and get the SD
fprintf(1, 'Std Deviation diam in degrees: %.2f\n', convert2VisAngle(diam_sd) )

minSize = 15; maxSize = 150;  %% SS FIXME: copied from generateSet.m
fprintf(1, 'Range of allowable diameters: [%.2f, %.2f]\n', convert2VisAngle(minSize), convert2VisAngle(maxSize))

fixationLength = 10;  % copied from runHet.m
fprintf(1, 'Fixation arm length (deg): %.2f\n', convert2VisAngle(sqrt(2)*fixationLength) ) % diagonal

closestX = min(abs(loc12(:,1)));  closestY = min(abs(loc12(:,2)));
fprintf(1, 'Min spacing from fixation (max size at closest pt): %.2f\n', ...
	convert2VisAngle(pairSpacing(maxSize/2,[closestX closestY],0,[0,0])))
fprintf(1, 'Furthest dist from fix: %.2f\n', max(dists_from_fix))

