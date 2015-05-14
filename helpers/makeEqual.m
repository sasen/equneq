function [stimfilename, trials] = makeEqual(n,m1,m2,numTrials)
% function [stimfilename, trials] = makeEqual(n,m1,m2,numTrials)
% makeEqual  Makes eg 20 trials of 6_60/6_80, for m1=60, m2=80

pos{n} = fixedPositions(n); % get positions (pos is a cell array to accomodate unequal trials)
trialType = round(n/6);  % either trialType 1 (6/6) or 2 (12/12)

one = generateSet(n,m1,numTrials);
two = generateSet(n,m2,numTrials);

if m1 > m2
  correct = 'l';
elseif m2 > m1
  correct = 'r';
else % m1 == m2; unclear what to say %% FIXME?
  correct = 'x';
end

% assign TWICE each (reshuffled)
% this will need to change if positions are not fixed
trField = cell(numTrials,2);
trials = struct('Lcirs',trField, 'Rcirs',trField, 'trialType', trialType, 'trialRightAnswers',correct, ...
		'Lmean',m1, 'Rmean',m2);
for tr = 1:numTrials
  set1 = [pos{n} one(tr,:)'];
  set2 = [pos{n} two(tr,:)'];
  set1shuf = [pos{n} shuffle(one(tr,:)')];
  set2shuf = [pos{n} shuffle(two(tr,:)')];
  trials(tr,1).Lcirs = set1;
  trials(tr,1).Rcirs = set2;
  trials(tr,2).Lcirs = set1shuf;
  trials(tr,2).Rcirs = set2shuf;
end  % for tr (trials)
trials = shuffle([trials(:)]);

stimfilename = strcat('type',num2str(trialType),'_',num2str(m1),'_',num2str(m2),'.mat')
save(stimfilename,'trials');