function stimfilename = makeEqual(n,m1,m2)
% function stimfilename = makeEqual(n,m1,m2)
% makeEqual  Generates and saves pairs of stimuli for equal-type trials
%  n (pos int): set-size for each side. only works for 6 or 12 right now
%  m1, m2 (pos real): means 1 and 2 for the sets
%  stimfilename (string): .mat filename to load in main experiment
% Note: currently positions are on a grid, which is sad.

%% FIXME: hey, why am I not taking all the radius-lists and displaying them on both sides, with
%  positions scrambled? maybe even a few times on each side, scrambling positions. that would be cool
%  for l/r bias arguments, or for split-half analysis. in which case, i should just generate the trials
%  and shuffle them together.

xx = linspace(1,640,3+1);
xpos = xx(2:end) - diff(xx)/2;
yy = linspace(1,400,2+1);
ypos = yy(2:end) - diff(yy)/2;
[allx,ally] = meshgrid(xpos,ypos);
posfor6 = [allx(:) ally(:)];
ypos2 = [ypos ypos+400];
[allx,ally2] = meshgrid(xpos,ypos2);
posfor12 = [allx(:) ally2(:)];

% make <=100 trials
one = generateSet(n,m1);
two = generateSet(n,m2);
% trim blindly (some trimmed ones might be easier to place onscreen, oh well)
numTrials = min(length(one),length(two));
one = one(1:numTrials,:);
two = two(1:numTrials,:);

%%% old approaches
%big = [big6; big12] %%%%% HEREHERE FIXME oh no, we need cells
%big = load('six75.mat');
%lil = load('six55.mat');
%numTrials = min(size(big.usefulCands,1),size(lil.usefulCands,1));
%numTrials = min(size(big12,1),size(lil12,1));
%big = big.usefulCands(1:numTrials,:);
%lil = lil.usefulCands(1:numTrials,:);
%big = big12(1:numTrials,:);
%lil = lil12(1:numTrials,:);

% Randomly assign big/lil to left/right sides
sides = 'lr';
trialRightAnswers = sides( randi(length(sides),numTrials,1) );

% Need to generate a trialType vector
% Trial types. For now: 1=6/6, 2=12/12, 3=6/12, 4=12/6
% Doesn't matter which side is bigger, or what the mean ratio is (related!)
% Not sure if this even makes any sense. But it's a start. SS FIXME
switch n
 case 6
  trialType = 1;
  posList = posfor6;
 case 12
  trialType = 2;
  posList = posfor12;
 otherwise
  trialType = NaN;  %% can't handle unequal yet
end

trField = cell(numTrials,1);
trials = struct('Lcirs',trField, 'Rcirs',trField, 'trialType',trField, 'trialRightAnswers',trField, ...
		'Lmean',trField, 'Rmean',trField)
for tr = 1:numTrials
  % who's actually bigger?
  list1 = one(tr,:)';
  list2 = two(tr,:)';
  if mean(list1) > mean(list2)
    big = list1;
    lil = list2;
  else
    big = list2;
    lil = list1;
  end
  assert(abs(mean(list1)-m1)<0.01,'%s: List 1 radius generation is broken.',mfilename)
  assert(abs(mean(list2)-m2)<0.01,'%s: List 2 radius generation is broken.',mfilename)

  if strcmp(trialRightAnswers(tr),'l')
    trials(tr).Lcirs(:,:) = [posList big];
    trials(tr).Rcirs(:,:) = [posList lil];
    trials(tr).Lmean = mean(big);
    trials(tr).Rmean = mean(lil);
  elseif strcmp(trialRightAnswers(tr),'r')
    trials(tr).Lcirs(:,:) = [posList lil];
    trials(tr).Rcirs(:,:) = [posList big];
    trials(tr).Lmean = mean(lil);
    trials(tr).Rmean = mean(big);
  else
    error('%s: %s should be l or r.',mfilename,trialRightAnswers(tr))
  end  % strcmp trialRightAnswers(tr)
  trials(tr).trialRightAnswers = trialRightAnswers(tr);
  trials(tr).trialType = trialType;
end  % for tr (trials)

stimfilename = strcat('type',num2str(trialType),'_',num2str(m1),'_',num2str(m2),'.mat')
save(stimfilename,'trials','trialRightAnswers','trialType','numTrials');