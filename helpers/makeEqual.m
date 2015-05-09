function [stimfilename, trials] = makeEqual(n,m1,m2)
% function [stimfilename, trials] = makeEqual(n,m1,m2)
% makeEqual  Makes eg 6_60/6_80, for m1=60, m2=80

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

trialType = round(n/6);

% make <=100 trials
one = generateSet(n,m1);
two = generateSet(n,m2);
% trim blindly (some trimmed ones might be easier to place onscreen, oh well)
numTrials = min(length(one),length(two));
one = one(1:numTrials,:);
two = two(1:numTrials,:);

if m1 > m2
  correct = 'l';
elseif m2 > m1
  correct = 'r';
else % m1 == m2; unclear what to say %% FIXME?
  correct = 'x';
end

% assign TWICE each (reshuffled)
% this will need to change when positioner works
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
save(stimfilename,'trials','numTrials');  % numTrials is a lie, mult by 2? FIXME