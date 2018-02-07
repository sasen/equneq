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

%% I'm taking all the diameter-lists and displaying them on both sides, and again with
%  positions scrambled. this could be cool for l/r bias arguments, or for split-half analysis. 

pos{n1} = fixedPositions(n1); % get positions (pos is a cell array to accomodate unequal trials)
pos{n2} = fixedPositions(n2);

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
else % m1 == m2
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