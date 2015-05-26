function [err, bic] = errFunction2(p,fl,data)
% (from jserences), modified by sasen for consistency
% this version will also return BIC (will slow it down a bit, but this
% will make model comparison easier)

err = errFunction(p,data);  % using same errFunction() & model()!

% bic = number of data points * log(rmse) + (number of parameters *
% log(number of data points))
n = numel(data);
k = numel(fl);
bic = n * log(err/n) + (k*log(n));

