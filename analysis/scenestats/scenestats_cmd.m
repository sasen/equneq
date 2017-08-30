stimfname = 'allStimuli123_6.mat';  % if not on path, it's in equneq/
load(stimfname); % all trials and parameters

pgmdir = '~/Dropbox/ucsd/projects/fyp/expts/stimuli_tufts/ensemble_screenshots/pgm_format/';

%% limit to just 12/12 (or whatever)
blocktype = 'd';
trials = dTr;
trType = 4; 
fnameString = '12vs6';

trMax =  numel(trials)  % 408 trials for same or diff

rsz = 256;  % in pixels, choose power of 2 for texture analysis!
screenheight = 1080;   screenwidth = 1920;   % for Tufts experiment
hmin = screenheight/2;
lwmin = screenwidth/2 - (rsz*2);
rwmin = screenwidth/2 +  rsz;
hmax = hmin + rsz - 1;
lwmax = lwmin + rsz - 1;
rwmax = rwmin + rsz - 1;
%[hmin hmax 0 lwmin lwmax 0 rwmin rwmax]

ratios = sizes(:,1)./sizes(:,2);
% 17 psy ticks. recover these
% make difficulty bins
% 1 -9: easyR = 1:3, 
% 2 -1: hardR = 6:8, 
% 3 +1: hardL = 10:12, 
% 4 +9: easyL = 15:17, 
% 0  0: otherwise (4, 5, 9, 13, 14)
excludeTr = zeros(size(trials));
psyTickTr = zeros(size(trials));
difficTr = zeros(size(trials));
%% quick loop to figure out trial types and difficulty bins
for ttt = 1:numel(trials)  %% don't do anything slow here, just use trials struct
  T = trials(ttt);
  if T.trialType ~= trType   % skip 6/6 (or undesired trial types)
    excludeTr(ttt) = 1;
  end  % exclude
  psyTick = find(abs(ratios-T.Lmean/T.Rmean) < eps);
  psyTickTr(ttt) = psyTick;
  switch psyTick
    case {1, 2, 3}   % easyR
      difficTr(ttt) = 1; 
    case {6, 7, 8}   % hardR
      difficTr(ttt) = 2; 
    case {10, 11, 12}   % hardL
      difficTr(ttt) = 3; 
    case {15, 16, 17}   % easyL
      difficTr(ttt) = 4; 
  end % switch psyTick
end % for ttt, quick loop

% to store texture statistics by psyTick
tsL = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}};
tsR = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}};

% to visualize average image in this pooling region, by difficulty bins
lavg = zeros(rsz, rsz, 4,'double'); 
ravg = zeros(rsz, rsz, 4, 'double');

%% go through trial screenshots
for tr = 1:trMax
  T = trials(tr);
  if excludeTr(tr) == 1
    fprintf('Skip %d of type %d\n', tr, T.trialType);
    continue
  end % if exclude

  fnamestem = strjoin( {'screenshot', blocktype, num2str(tr)}, '_' );
  pgmname = [fullfile(pgmdir, fnamestem) '.pgm'];
  screenpgm = imread(pgmname);    %  imshow(screenpgm)

  %% grab symmetric pooling regions for each ensemble
  lregion = double(screenpgm(hmin:hmax, lwmin:lwmax));
  rregion = double(screenpgm(hmin:hmax, rwmin:rwmax));

  %% make heatmaps by difficulty (mean ratio) bin
  diffic = difficTr(tr);
  if diffic > 0
    lavg(:,:,diffic) = lavg(:,:,diffic) + (lregion/255);
    ravg(:,:,diffic) = ravg(:,:,diffic) + (rregion/255);
  end  % if difficulty

  %% compute texture statistics, organize by psychometric function abscissa
  psyTick = psyTickTr(tr);
  tsL{psyTick}{end+1} = textureAnalysis(lregion,4,4,9);
  tsR{psyTick}{end+1} = textureAnalysis(rregion,4,4,9);

end  % going through screenshots 

%% plot L and R heatmaps (avg image in pooling region) by difficulty (mean ratio) bins
figure; 
subplot(421), imagesc(lavg(:,:,1)), subplot(422), imagesc(ravg(:,:,1))
subplot(423), imagesc(lavg(:,:,2)), subplot(424), imagesc(ravg(:,:,2))
subplot(425), imagesc(lavg(:,:,3)), subplot(426), imagesc(ravg(:,:,3))
subplot(427), imagesc(lavg(:,:,4)), subplot(428), imagesc(ravg(:,:,4))

subplot(421), title('Left Visual Field'), ylabel('Easy R')
subplot(422), title('Right Visual Field')
subplot(423), ylabel('Hard R')
subplot(425), ylabel('Hard L')
subplot(427), ylabel('Easy L')

savefname = ['textureStats_1pool_' fnameString '.mat'];
save(savefname,'trials','tsL','tsR','excludeTr','difficTr','psyTickTr','lavg','ravg','hmin','lwmin','rwmin','rsz','blocktype','trType');