function tot = totOfSet(diamrows)
%function tot = totOfSet(diamrows)
% diamrows = lists of circle diameters; each row is a set
% tot = total area of the set of circles
tot = sum(pi*(diamrows./2).^2,2);

