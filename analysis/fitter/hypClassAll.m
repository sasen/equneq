function pstar = hypClassAll(tickVal,data,counts)
% function pstar = hypClassAll(tickVal,data,counts)
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
freeList = {'m','s','g','l'};  % parameters of cumulative normal below
p.m = 0;        % mean
p.s = 0.05;      % std
p.g = 0;        % gamma/guess
p.l = 0;        % lambda/lapse

%% Make Model Hypothesis Classes
pnum = numel(freeList);  % original number of parameters, 4
nModels = 2^pnum-1; % because 16th model has 0 parameters!
fl = cell(nModels,1); 

% truth-table approach: go through 1:15 in binary as "logical indexes" in freeList
varnum = 1:pnum;  % 1:4   need this to index into freeList
for mm = 1:nModels  % 1:15 
    % this generates all 4-bit combinations of indices into freeList
    fl{mm} = freeList(varnum(logical(str2num(dec2bin(mm,pnum)'))));
end

%% Make Jittered Seeds For Restarts
nIters = 15; % number of restarts we will do
mindata = mean([min(data) 0]); % for gamma. min, pulled outward
maxdata = mean([max(data) 1]); % for lambda. max, pulled outward
Jit.m = [p.m; randn(nIters,1)/5]; 
Jit.s = [p.s; rand(nIters,1)];
Jit.g = [p.g; mindata + (0.5-mindata)*rand(nIters,1)];
Jit.l = [p.l; 1 - (0.5 + (maxdata-0.5)*rand(nIters,1))];
nIters = numel(Jit.m);

%% OK, Now go through each hyp class and fit, jittering seeds
pmodstars = []; bicmodels = nan(nModels,1); errmodels = bicmodels;
for mm = 1:nModels  
    pjitstars = []; errjit = nan(nIters,1);
  for ii = 1:nIters  % new jitter at each iter :-)

    pjit = p;   % 0. Assign all as fixed params first
    for pp = 1:numel(fl{mm})     % 1. Assign free params with jitter
      param = char(fl{mm}(pp));
      pjit.(param) = Jit.(param)(ii);
    end  % go through params
    pjitstars(ii).p = fit('errFunction',pjit,fl{mm},data); % 2. Fit this beastie!
    errjit(ii) = errFunction(pjitstars(ii).p,data);
  end % restarts with jitter    

  [~, ind] = min(errjit); % find the lowest error seed
  pmodstars(mm).p = pjitstars(ind).p; % save best params for this hyp class
  subplot(6,3,mm), plot(p.x, data, 'k'), hold on
  plot(p.x, model(pmodstars(mm).p),'LineWidth',2) % thicken the optimized one
  myp = pmodstars(mm).p;
  pstr = sprintf('%d (%s): %.2f %.2f %.2f %.2f',mm,char(fl{mm}),myp.m,myp.s,myp.g,myp.l);
  fprintf(1,'%s\n',pstr);
  title(pstr); axis([-1 1 0 1])
  drawnow
  [errmodels(mm), bicmodels(mm)] = errFunction2(pmodstars(mm).p,fl{mm},data); % BIC
end % fitting each hyp class

%% FIXME maybe I want to always lets m and/or s vary? 
% so just a matter of whether g, l, both, or neither are allowed to vary?
% this can be winnowed down later, by recalculating BIC

[bicstar, mNum] = min(bicmodels); % find the lowest BIC hyp class
errstar = errmodels(mNum); % corresponding SSE
pstar = pmodstars(mNum).p;  % save best params over all hyp classes
pstr=sprintf('BEST %d (%s): %.2f %.2f %.2f %.2f',mNum,char(fl{mNum}),pstar.m,pstar.s,pstar.g,pstar.l)

subplot(6,2,11),plot(errmodels,'ro-')
title('Optimized Model Errors'); ylabel('Sum Sq. Error')
subplot(6,2,12),plot(bicmodels,'bx-')
title('Optimized Model BIC Values')
hold on; plot(mNum,bicstar,'k.','MarkerSize',20)
xlabel('Model Number'); ylabel('BIC')
