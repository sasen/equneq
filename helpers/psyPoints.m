%function paramFilename = psyPoints(mStandard,nPairs,nTicks,debug)
% function paramFilename = psyPoints(mStandard,nPairs,nTicks,debug)
% mStandard: mean size in pixels of standard set (aim for 40 to 130)
% nPairs: # unique sets per means (m1 and m2 values); will be doubled
% nTicks (pos ODD int): # of ticks in the psychometric function horizontal axis
% debug: lets you make less than 200 trials per curve.
% switch nargin
%  case 0
%   error('%s needs at least 1 input, the standard size.',mfilename)
%  case 1
%   nPairs = 7; nTicks = 15; debug = 0;
%  case 2
%   error('%s would prefer you specified both or neither of nPairs and nTicks.',mfilename)
%  case 3
%   debug = 0;
% end
assert(mod(nTicks,2)==1, '%s: nTicks must be odd! But it is %f.',mfilename,nTicks)

NREPS = 2; nTrialsPerTick = nPairs*NREPS;
nPerPsy = nTrialsPerTick * nTicks;
if ~debug  % need 200 trials per curve
  assert(nPerPsy >= 200,'Need at least 200 trials per curve, but only have %f.',nPerPsy)
end

% get number of curves
nConds = 2; % isolated (same xor diff) vs mixed
nTrialTypes = 4; % 6/6, 12/12, 6/12, 12/6
nCurves = nTrialTypes * nConds;
% num total trials
nTotalTrials = nPerPsy * nCurves;
%%%%%% FIXME this doesn't count practice!

%timePerTrial_est = 0.5 + 0.2 + 1.5; % (sec) fixation + presentation + estimated mean RT/ITI
timePerTrial_est = 0.2 + 0.2 + 1.5; % (sec) fixation + presentation + estimated mean RT/ITI
minTaskTime = nTotalTrials * timePerTrial_est / 60;  % (min)

% mbase = 64;
% ls = logspace(-2,2,nTicks);
% lin = [-2:4/(nTicks-1):2];
% explin = 10.^lin;
% [ls' explin'];
% explin = 2.^lin';
% nonbase = explin*mbase;
% nonbase((nTicks+1)/2:end);
% log2(nonbase/mbase);

halfTicks = (nTicks-1)/2;
%ls3x = logspace(log10(1/3),0,(nTicks+1)/2);
ls3x = logspace(log10(1/2),0,halfTicks+1);
weights = [[ ls3x; ones(1,halfTicks+1)] [ones(1,halfTicks); ls3x([halfTicks:-1:1])] ]';
sizes = weights*mStandard;

%% FIXME verify that the mean works the same as individual values.
totL = [mean2tot(sizes(:,1),6); mean2tot(sizes(:,1),12); mean2tot(sizes(:,1),6); mean2tot(sizes(:,1),12)];
totR = [mean2tot(sizes(:,2),6); mean2tot(sizes(:,2),12); mean2tot(sizes(:,2),12); mean2tot(sizes(:,2),6)];
totratio = (totL ./ totR) + rand(size(totL))*0.01;
ltotrat = reshape(log2(totratio),17,4);
tickVals = sizes(:,1) ./ sizes(:,2);
plot(log2(tickVals),ltotrat,'o-'); axis tight
legend('6v6','12v12','6v12','12v6','Location','NorthWest')

%paramFilename = strcat(['params',num2str(mStandard),'_nPairs',num2str(nPairs),'.mat']);
%save(paramFilename);
