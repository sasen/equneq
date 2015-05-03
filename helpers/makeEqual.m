%should probably become a "makeEqual" function
n = 12; m1 = 55, m2 = 60;

xx = linspace(1,640,3+1);
xpos = xx(2:end) - diff(xx)/2;
yy = linspace(1,400,2+1);
ypos = yy(2:end) - diff(yy)/2;
[allx,ally] = meshgrid(xpos,ypos);
posfor6 = [allx(:) ally(:)];
ypos2 = [ypos ypos+400];
[allx,ally2] = meshgrid(xpos,ypos2);
posfor12 = [allx(:) ally2(:)];
%[repmat(posfor6(1:2,:),2,1);repmat(posfor6(3:4,:),2,1);repmat(posfor6(5:6,:),2,1)] - posfor12

% grab some sets (nominally) within tolerance; trim blindly
one = generateSet(n,m1);
two = generateSet(n,m2);
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

Lcirs = nan(n,3,numTrials);  Rcirs = nan(n,3,numTrials); 
Lmean = nan(numTrials,1);    Rmean = nan(numTrials,1);
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

  if strcmp(trialRightAnswers(tr),'l')
    Lcirs(:,:,tr) = [posList big];
    Rcirs(:,:,tr) = [posList lil];
    Lmean(tr) = mean(big);
    Rmean(tr) = mean(lil);
  elseif strcmp(trialRightAnswers(tr),'r')
    Lcirs(:,:,tr) = [posList lil];
    Rcirs(:,:,tr) = [posList big];
    Lmean(tr) = mean(lil);
    Rmean(tr) = mean(big);
  else
    error('%s: %s should be l or r.',mfilename,trialRightAnswers(tr))
  end  % strcmp trialRightAnswers(tr)
end  % for tr (trials)

stimfilename = strcat('type',num2str(trialType),'_',num2str(m1),'_',num2str(m2),'.mat')
save(stimfilename,'Lcirs','Rcirs','trialRightAnswers','trialType','numTrials','Lmean','Rmean');