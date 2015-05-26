function [data,p] = fakeCNorm
% ss 05242015
% js 04072015
% use a cumulative gaussian to generate a fake data set 
% note: run this as a standalone script and it will save the fake data 
% in the 'data.mat' file that you can then load and fit in the 'class_xxxx.m' function

%close all;
%clear all;

% set up a variable that determines how much noise there is...
n = .05;

% set up some parameters that govern the shape of the data
[tickVal,ns,afcs] = aggregatePsy('ssc');  % overkill
fitme = randi(size(ns,2));   % which curve to fit?
p.n = ns(:,fitme)';    % num valid trials at that x

p.x = log2(tickVal);% x-axis
p.m = -0.17;     % mean
p.s = 0.15;      % std
p.g = 0.0833;     % gamma/guess
p.l = 0;    % lambda/lapse
p.plot = 1;

cn = model(p);
plot(p.x, cn, 'b', 'LineWidth', 2), hold on

% then lets add some noise and replot
data = cn+randn(size(cn))*n;
% clip into [0,1] range
data(find(data>1)) = 1;
data(find(data<0)) = 0;
plot(p.x, data, 'k')

legend({'Ideal data', 'Fake data (with IID noise)'})
save data 
p.data = data;