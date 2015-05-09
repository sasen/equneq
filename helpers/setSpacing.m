function [minSpacing spac] = setSpacing(cirs)
% function [minSpacing spac] = setSpacing(cirs)
% Given a set of circle positions & radii, return mutual spacing
n = size(cirs,1);
spac = nan(n);
for c1 = 1:n
  r1 = cirs(c1,3)/2;  pos1 = cirs(c1,1:2);
  for c2 = 1:c1
    r2 = cirs(c2,3)/2;  pos2 = cirs(c2,1:2);
    spac(c1,c2) = pairSpacing(r1,pos1,r2,pos2);
  end
end
spac = diag(inf(n,1)) + spac
minSpacing = min(min(spac))

