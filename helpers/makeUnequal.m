function [stimfilename, trials] = makeUnequal(n1,n2,m1,m2,numTrials)
% function stimfilename = makeUnequal(6,12,m1,m2)
% makeUnequal  Generates and saves pairs of stimuli for unequal-type trials
%  n1,n2 (pos int): set-size for each side. only works for n1=6, n2=12 now
%  m1, m2 (pos real): means 1 and 2 for the sets.
%  numTrials (pos int): how many unique trials to make
%  stimfilename (string): .mat filename to load in main experiment
%  trials (struct array)
% Note: currently positions are on a grid, which is sad.

% assert(n1 <= n2,'Can you try that again with  n1 <= n2, please?')  % maybe someday
assert(n1 < n2,'Can you try that again with  n1 < n2, please?')

%% FIXME: hey, why am I not taking all the radius-lists and displaying them on both sides, with
%  positions scrambled? maybe even a few times on each side, scrambling positions. that would be cool
%  for l/r bias arguments, or for split-half analysis. in which case, i should just generate the trials
%  and shuffle them together.

% thinking: we need a setID maybe? or a pairID? or both
% from this: 6,12,60,80, we can get:
% these displays: 6_60, 6_80, 12_60, 12_80 which can appear on the left and right.
% in both separate and mixed!! <-- get another stage to do this mixing (or read in)
% and presented twice each, scrambled!  <-- runHet can't do this... need new positions.
% to get the second position thing, i should just call the position getter after shuffling the list order.

% 6_60 / 6_80  % i lied. this should be from 6,6,60,80
% 6_80 / 6_60 (fix)
% 12_60 / 12_80   % and this from 12,12,60,80
% 12_80 / 12_60 (fix)
% 6_80 / 12_60   % and this from 6,12,80,60
% 12_60 / 6_80

%%%%%%%%%%%%%% so really, it's just...
% 6_60 / 12_80
% 12_80 / 6_60

% this takes the place of positioner()
xx = linspace(1,640,3+1);
xpos = xx(2:end) - diff(xx)/2;
yy = linspace(1,400,2+1);
ypos = yy(2:end) - diff(yy)/2;
[allx,ally] = meshgrid(xpos,ypos);
pos{6} = [allx(:) ally(:)];
ypos2 = [ypos ypos+400];
[allx,ally2] = meshgrid(xpos,ypos2);
pos{12} = [allx(:) ally2(:)];

one = generateSet(n1,m1,numTrials);
two = generateSet(n2,m2,numTrials);

eqTypeMod = 0;
% % argh, not sure this is gonna work. just do separately for now
% if n1==n2
%   eqTypeMod = -2;
% end

if m1 > m2
  type3correct = 'l';
  type4correct = 'r';
elseif m2 > m1
  type3correct = 'r';
  type4correct = 'l';
else % m1 == m2; unclear what to say %% FIXME?
  type3correct = 'x';
  type4correct = 'x';
end

% assign to both type 3 and type 4 trials... TWICE each (reshuffled)
% this will need to change when positioner works
trField = cell(numTrials,2);
trials3 = struct('Lcirs',trField, 'Rcirs',trField, 'trialType', 3+eqTypeMod, 'trialRightAnswers',type3correct, ...
		'Lmean',m1, 'Rmean',m2);
trials4 = struct('Lcirs',trField, 'Rcirs',trField, 'trialType', 4+eqTypeMod, 'trialRightAnswers',type4correct, ...
		'Lmean',m2, 'Rmean',m1);
for tr = 1:numTrials
  set1 = [pos{n1} one(tr,:)'];
  set2 = [pos{n2} two(tr,:)'];
  set1shuf = [pos{n1} shuffle(one(tr,:)')];
  set2shuf = [pos{n2} shuffle(two(tr,:)')];
  trials3(tr,1).Lcirs = set1;
  trials3(tr,1).Rcirs = set2;
  trials4(tr,1).Lcirs = set2;
  trials4(tr,1).Rcirs = set1;
  trials3(tr,2).Lcirs = set1shuf;
  trials3(tr,2).Rcirs = set2shuf;
  trials4(tr,2).Lcirs = set2shuf;
  trials4(tr,2).Rcirs = set1shuf;
end  % for tr (trials)
trials = shuffle([trials3(:); trials4(:)]);

stimfilename = strcat('type3and4_',num2str(m1),'_',num2str(m2),'.mat')
save(stimfilename,'trials');