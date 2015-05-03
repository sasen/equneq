%should probably become a "makeEqual" function

xx = linspace(1,640,3+1);
xpos = xx(2:end) - diff(xx)/2;
yy = linspace(1,400,2+1);
ypos = yy(2:end) - diff(yy)/2;
[allx,ally] = meshgrid(xpos,ypos);
posfor6 = [allx(:) ally(:)];
ypos2 = [ypos ypos+400];
[allx,ally2] = meshgrid(xpos,ypos2);
posfor12 = [allx(:) ally2(:)];

%big6 = generateSet(6,55);
%lil6 = generateSet(6,45);
lil12 = generateSet(12,55);
big12 = generateSet(12,60);
%big = [big6; big12] %%%%% HEREHERE FIXME oh no, we need cells
%big = load('six75.mat');
%lil = load('six55.mat');
%numTrials = min(size(big.usefulCands,1),size(lil.usefulCands,1));
numTrials = min(size(big12,1),size(lil12,1));
%big = big.usefulCands(1:numTrials,:);
%lil = lil.usefulCands(1:numTrials,:);
big = big12(1:numTrials,:);
lil = lil12(1:numTrials,:);


% Randomly assign big/lil to left/right
sides = 'lr';
trialRightAnswers = sides(randi(2,numTrials,1));

% Need to generate a trialType vector

% Need to make this work for 6/12 & 12/6 trials
for tr = 1:numTrials
  % FIXME: need to verify that big is actually bigger mean than lil!
  if strcmp(trialRightAnswers(tr),'l')
    Lcirs(:,:,tr) = [posfor12 big(tr,:)'];
    Rcirs(:,:,tr) = [posfor12 lil(tr,:)'];
  elseif strcmp(trialRightAnswers(tr),'r')
    Lcirs(:,:,tr) = [posfor12 lil(tr,:)'];
    Rcirs(:,:,tr) = [posfor12 big(tr,:)'];
  else
    error('justplaying.m: %s should be l or r.',trialRightAnswers(tr))
  end  % strcmp trialRightAnswers(tr)
end  % for tr (trials)

save('some12.mat','Lcirs','Rcirs','trialRightAnswers','numTrials')