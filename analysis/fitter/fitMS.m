function [m, s, pstar] = fitMS(tickVal,data,counts)
% function [m, s, pstar] = fitMS(tickVal,data,counts)
%clear all; close all;
%subj = '003'; cNum = 4;
%[tickVal,ns,afcs] = aggregatePsy(subj);
%  tickVal=log2(tickVal) % psychometric function x-axis
%  data = afcs(:,cNum)'; % proportion chose left at that x
%  counts = ns(:,cNum)';    % num valid trials at that x

if size(tickVal) ~= size(counts)   % reshaping if needed
  tickVal = tickVal';
end

p.n = counts;    % num valid trials at that x
p.x = tickVal;  % x-axis
%%
p.plot = 0;
p.shutup = 1;
freeList = {'m','s'};  % parameters of cumulative normal below
p.m = 0;        % mean
p.s = 0.1;      % std
p.g = 0;        % gamma/guess
p.l = 0;        % lambda/lapse

%% Make Jittered Seeds For Restarts
nIters = 15; % number of restarts we will do
Jit.m = [p.m; randn(nIters,1)/5]; 
Jit.s = [p.s; rand(nIters,1)];
nIters = numel(Jit.m);

%% Fit, jittering seeds
pjitstars = []; errjit = nan(nIters,1);
for ii = 1:nIters  % new jitter at each iter :-)
  pjit = p;   % 0. Assign all as fixed params first
  for pp = 1:numel(freeList)     % 1. Assign free params with jitter
    param = char(freeList(pp));
    pjit.(param) = Jit.(param)(ii);
  end  % go through params
  pjitstars(ii).p = fit('errFunction',pjit,freeList,data); % 2. Fit this beastie!
  errjit(ii) = errFunction(pjitstars(ii).p,data);
end % restarts with jitter    

[~, ind] = min(errjit); % find the lowest error seed
pstar = pjitstars(ind).p; % save best params for this hypothesis class
m = pstar.m;
s = pstar.s;
