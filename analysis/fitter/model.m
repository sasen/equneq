function pred = model(p)

% function parameter
%m - mu (mean)
%s - sigma (standard deviation, threshold)
%g - gamma (guess rate, baseline response)
%l - lambda (lapse rate)
%x - x axis (levels)

pred = p.g + (1-p.g-p.l).*normcdf(p.x, p.m, p.s);
%pred = p.a*exp(p.k*(cos(p.u-p.x)-1))+p.b;
