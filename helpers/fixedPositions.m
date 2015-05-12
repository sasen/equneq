function posXY = fixedPositions(n)
% function posXY = fixedPositions(n)
% fixedPositions  Deterministic positions for 6 or 12 items;
% only needs to be called once to generate for each set-size.
%  n (pos int): number of items in set
%  posXY (nx2 pos reals): each row is [X Y] (px) of item's center
% Note: the screen res is fixed right now to 640x800 (1/2 laptop).
assert(n==6 || n==12,'Input argument n must be either 6 or 12, but it is %f.',n)
hMarg = 20; % horizontal margin in px (LR-edge/fixation)
vMarg = 20; % vertical margin in px (top/bot)

% first make 4x3 grid (even if fewer items requested)
xx = linspace(1+hMarg,640-hMarg,3+1);
xpos = xx(2:end) - diff(xx)/2;
yy = linspace(1+vMarg,800-vMarg,4+1);
ypos = yy(2:end) - diff(yy)/2;
[allx,ally] = meshgrid(xpos,ypos);
switch n
 case 6
%  spots = [1 9 6 7 4 12];  % 4 corners and 2 inner positions
  spots = [2 3 5 8 10 11];  % vertical oval configuration
 case 12
  spots = 1:n;
end

posXY = [allx(spots)' ally(spots)'];
