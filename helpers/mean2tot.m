function tot = mean2tot(diam,n)
%function tot = mean2tot(diam,n)

radius = diam ./ 2;
area = pi .* radius.^2;
tot = n .* area;
