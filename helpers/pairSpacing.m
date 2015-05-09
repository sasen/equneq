function spacing = pairSpacing(r1,pos1,r2,pos2)
% function spacing = pairSpacing(r1,pos1,r2,pos2)
% pairSpacing  Takes pair of circles, computes spacing/overlap
%   r1,r2 (pos real): radius of circle 1 or 2, in px
%   pos1,pos2 (1x2 pos real): [x y] coordinates of circle 1 or 2, in px
%   spacing (real): pixels between pair of circles. < 0 means overlap.
% Note: To check distance to a point, use radius=0.
distance = norm(pos1-pos2, 2);
spacing = distance - (r1 + r2);