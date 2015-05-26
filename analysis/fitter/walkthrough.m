%% Sasen reinvents psignifit the hard way. sasen@ucsd.edu
%Week 3, PSYC 231 - model fitting (fminsearch/exhaustive search methods), andn BIC-based model selection
% js (jserences@ucsd.edu): version 04072015 (note: this tutorial calls the
% magic 'fit' function that was written by Geoff Boynton in the summer of 2000)
clear all; close all;
% load some 'real' data that we want to characterize - you can generate
% this using the 
[data,fakep] = fakeCNorm;

[tickVal,ns,afcs] = aggregatePsy('ssc');
%%
fitme = 1; 
p.realdata = afcs(:,fitme)';
data = p.realdata;
p.n = ns(:,fitme)';    % num valid trials at that x
p.x = log2(tickVal);  % x-axis
p.m = 0;        % mean
p.s = 0.3;      % std
p.g = 0;        % gamma/guess
p.l = 0;        % lambda/lapse
p.plot = 1;

pred = model(p);
close all;
plot(pred, 'b', 'LineWidth', 2), hold on
plot(data, 'k', 'LineWidth', 2)
legend({'Initial Guess (prediction)', 'Real observed data'})
set(gca, 'FontSize', 18)

err = errFunction(p,data);

%find best-fitting parameters using fminsearch  
freeList = {'m','s','g','l'};   %four free parameters that define the CN function above
bestP = fit('errFunction',p,freeList,data)
bestErr = errFunction(bestP,data)
fakep



%% generating restarts to ensure the best fit and to see if you can avoid
% getting stuck in local minima
nIters = 15;
tmpP = []; pred=[];
p.plot = 0;
mindata = mean([min(data) 0]); % for gamma. min, pulled outward
maxdata = mean([max(data) 1]); % for lambda. max, pulled outward
for i=1:nIters
    p.m = randn/5; 
    p.s = rand;
    p.g = mindata + (0.5-mindata)*rand;
    p.l = 1 - (0.5 + (maxdata-0.5)*rand);
    tmpP(i).p = fit('errFunction',p,freeList,data);
    pred(i,:) = model(tmpP(i).p);
    bestErr(i) = errFunction(tmpP(i).p,data);    
end

% plot the bestErr (or the error function from each iteration - what do you
% notice???
close all
plot(bestErr, 'LineWidth', 3), title('best err')

% find the best params that yeilded the lowest sse and use that
[~, ind] = min(bestErr);
bestB = tmpP(ind);
bestPred = pred(ind,:);

figure()
plot(p.x, data, 'k','LineWidth',2), hold on
plot(p.x, pred')
plot(p.x, bestPred,'p-' ,'MarkerSize', 10,'LineWidth',2)


% make some cleaner data to illustrate
clear all;
close all;

p.a = 1;
p.b = .1;
p.k = 2;
p.u = pi/2;
xsteps = 360;
xstepSize = (2*pi)/xsteps;
p.x = linspace(0, 2*pi-xstepSize, xsteps);
p.plot = 0;

% generate the data
data = model(p);

% then lets make a second experimental condition, and assume that in this
% condition, the data are scaled by a gain factor (i.e. a change in gain,
% characterized by a change in the 'amplitude' parameter, or p.a). Note
% that none of the other factors change, so {b, u, k} should stay the same
% across both models, and that is what we should recover after fitting both
% lines
p2 = p;
p2.a = 3;   % only change amp and baseline
data2 = model(p2);

% plot data and data2 (and notice that only the ampltiude has changed...)
figure(1), clf, hold on
plot(p.x, data)
plot(p.x, data2, 'k')
legend({'still', 'running'})
set(gca, 'FontSize', 24)

% now add some IID noise to both responses, just for fun
data = data + randn(size(data))*.1;
data2 = data2 + randn(size(data2))*.1;

% replot
figure(1), clf, hold on
plot(p.x, data)
plot(p.x, data2, 'k')
legend({'still', 'running'})
set(gca, 'FontSize', 24)

% now lets fit condition 1, and then ask, "what is the simplest model that
% we can adopt to account for data2 based on the best fitting parameters
% for data?" In other words, what is the minimum number of variables we can
% allow to vary freely between the two conditions in order to fit both
% lines?

% first fit data set 1 and allow all 3 variables to vary freely
freeList = {'a','b','k'};   %lets just use 3 params for simplicity (we'll fix u here)
bestP = fit('errFunction',p,freeList,data);

% now, we can consider all possible models that relate data and data2.
% 1) only the amp could vary (which we know is the correct model because 
%    that is how we set it up)
% 2) only the baseline (b) could vary
% 3) only k varies
% 4) a and b vary
% 5) a and k vary
% 6) b and k vary
% 7) a, b, and k vary (most complex)

% through these 7 alternative models using a cell array.
fl{1} = {'m'};
fl{2} = {'b'};
fl{3} = {'k'};
fl{4} = {'a','b'};
fl{5} = {'a','k'};
fl{6} = {'b','k'};
fl{7} = {'a','b','k'};

% loop over models and fit each one, storing the estimated params and the
% error of each model
for i=1:numel(fl)
    display(fl{i})
    freeList = fl{i};   %lets just use params for simplicity (we'll fix u here)
    bestP2{i} = fit('errFunction',bestP,freeList,data2); % initialize this with bestP (i.e. estimates from 'data')!!!
    [err(i), bic(i)] = errFunction2(bestP2{i},fl{i},data2); % now compute and store error for this model 
end

% note a few things...bestP2 compared to bestP - only the free param(s)
% should be different in each model
bestP2{1}
bestP

figure(1), clf, hold on
plot(err)
plot(bic)

% notice that error will be lowest with the most free parameters...why?
[m,i] = min(err)

% however, BIC will be lowest for the 'best' model (the most parsimonious,
% or the simplest model that best accounts for the data)...and that is
% (almost always) model 1!
[m, i] = min(bic)

% what happens if we vary other parameters like a and b? how does this hold
% up against noise?

% if you wanted to use nested f-tests to see if a more complex model is
% significantly better than a more simple model:
% F(df1, df2) = ((R2_full_model-R2_reduced_model)/df1)/ ((1-R2_full_model)/df2)
% df1 == #params in the full model - # params in reduced model
% df2 == #observations - number of the free params - 1
% where R2 = (1 - (RSS/TSS)), where TSS is the sum(pred-mean(data).^2)

%% intro to grid search in the 1D case
% another way to fit data, and one that is sometimes neccessary (see Vy's
% upcoming demo) is to use something called a grid search. So instead of
% letting matlab find the best fitting fucntion by moving around in a high
% dim space until the fit is optimized, you exhaustively (more or less)
% explore the full parameter space to find the best fitting function. This
% will not always work well, depending on how complex your function is, but
% in many cases its both fast and very robust (more robust than
% fminsearch).
% the basic idea is to loop over a bunch of values of all free params to
% see which set of them produces the best fit. Below we'll do this with
% some fake data generated with a VM function, and i'll show a few ways to
% speed things up by using a hueristic to find 'u' and a GLM to estimate
% the amplitude and the baseline of the functions. The following example is
% what you might use if you were fitting an orientation or direction
% selective neural tuning function...

clear all
close all

% make some data (can play with this to see how robust this method is to
% changes in params
d = MakeFakeData3;

numDataPnts = numel(d);
k = (.1:.1:15);             % pick a set of concentration (bandwidth) params for the VM functions that we're going to fit.
sse = zeros(numel(k), 1);
baseLine = zeros(numel(k), 1);
amps = zeros(numel(k), 1);

% in this case, we can speed things by using a hueristic to find 'u', or
% the center of the VM distribution - in this case just look within +-10%
% of the center of the function on the assumption that we've lined
% everything up so that the center orientation of our TF is in the middle
% of the data
[~, mind] = max(d(round(numDataPnts/2)-round(numDataPnts*.1):round(numDataPnts/2)+round(numDataPnts*.1)));
% then generate our x-axis
x = linspace(0, pi-pi/numDataPnts, numDataPnts);      
% then find our u param (or center point)
u = x(mind+round(numDataPnts/2)-round(numDataPnts*.1)-1);     

for ii=1:length(k)        
    a = 1;
    b = 0;
    pred = a*exp(k(ii)*(cos(u-x)-1)) + b;
    pred = scaleData(pred, 0, 1);
    X = zeros(numDataPnts,2);
    X(:,1) = pred';
    X(:,2) = ones(size(X,1),1);
    betas = X\d';
    amps(ii) = betas(1);
    baseLine(ii) = betas(2);
    est = pred*betas(1) + betas(2);
    sse(ii) = sum((est - d).^2);
end

% plot the error function! cool!!!
plot(sse) % non-monotonic...

% then find the best params
[~, mind] = min(sse);
b = baseLine(mind);
a = amps(mind); 
bwdth = k(mind);
% generate your prediction based on the best params
pred = a*exp(bwdth*(cos(u-x)-1)) + b;

close all
plot(d, 'k', 'LineWidth', 2), hold on
plot(pred, 'b', 'LineWidth', 2)