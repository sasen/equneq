function datafile = runHet(cond,subjCode)
% RUNHET   Run heterogeneous ensembles experiment
%   Spring 2015 // Comments to Sasen Cain sasen@ucsd.edu
%   cond (char) : condition 's', 'd', 'm' for same, different, or mixed trials
%% Experiment description
%
% Two ensembles of unfilled circles, to L and R of fixation. 
% Keypress 2-AFC on which side has greater mean diameter.
% Sets may have equal or unequal numbers of circles.
assert(nargin==2,'Two arguments, the condition code, and subject code, are required.')
assert(length(subjCode)==3,'subjCode must be 3 characters long.')
assert(ischar(subjCode),'Put that subjCode in single quotes!')

stimfile = 'allStimuli123_6.mat';
load(stimfile)
if ~exist('trials')
switch cond
 case 's'
  trials = sTr;
 case 'd'
  trials = dTr;
 case 'm'
  trials = mTr;
 otherwise
  error('%s: Condition %s not understood.',mfilename,cond)
end
end

% Create a directory for this subject's data
dirname=['het',subjCode];
pathdata=strcat(pwd,filesep,'..',filesep,'DATA',filesep,dirname,filesep); 
currBlock = 0; % this is a pain to expand

% New subject? Or has this subject started this condition yet?
if exist(pathdata,'dir')
  subjFiles = what(pathdata);
  fIndex = find(strncmp(cond,subjFiles.mat,1));  % find the index for this condition
else
  fprintf(1,'Starting new subject. Stimulus file is: %s',stimfile)
  sanityCheck = input('\n Are you happy with this? [y/n]:','s');
  if strcmp(sanityCheck,'n')
    disp('OK, maybe you should fix that.')
    return
  end
  mkdir(pathdata);
  fIndex = [];
end

% Allow restarting blocks (conds)
% Try to open the file for this condition if it exists; if not, make a new one!
switch length(fIndex==0)
 case 0
  % avoid overwriting! use time string in filename
  datafile = strcat(pathdata,cond,num2str(currBlock),'_',subjCode,'_time',datestr(now,'HH_MM_SS'));
  doneTrials = 0;
  % Preallocate 2AFC task response variables
  totTrials = length(trials);  % FIXME: this needs to be blocked!!
  choices = cell(totTrials,1);   % record ANY keypress
  afcL    = nan(totTrials,1);    % chose left in 2afc
  RTs     = nan(totTrials,1);    % reaction time (ANY button press) in ms since stimulus onset
  ACCs    = nan(totTrials,1);    % 2AFC: accuracy, Correct = 1, Incorrect = 0, No response/wrong key = NaN.
  expdata.block     = zeros(totTrials,1); % this is just to preallocate the expdata structure array too.
  expdata.trial     = nan(totTrials,1);
  expdata.veridical = [trials.trialRightAnswers];
  expdata.RTs       = RTs;
  expdata.choices   = choices;
  expdata.afcL      = nan(totTrials,1);
  expdata.ACCs      = ACCs;
  expdata.trialType = [trials.trialType];
  expdata.Lmean     = [trials.Lmean]; 
  expdata.Rmean     = [trials.Rmean];

 case 1   % found file already
  datafile = strcat(pathdata, subjFiles.mat{fIndex});
  load(datafile);
  doneTrials = nanmax(expdata.trial);   % how far have we progressed?
  % load the vectors we need
  choices = expdata.choices;
  afcL    = expdata.afcL;
  RTs     = expdata.RTs;
  ACCs    = expdata.ACCs;

 otherwise  % can't figure out which file it is
  error('%s too many matching files! cond %s, dir %s',mfilename,cond,pathdata)
end


%%%%%%%%%%%%%%%%%%%%%%%
% Stimulus parameters %
%%%%%%%%%%%%%%%%%%%%%%%
black = [  0   0   0];
white = [255 255 255];   
fixationLength = 10;  % length of lines in fixation cross
tFixation = 0.500;  % 500 ms fixation cross display
tDisplay  = 0.200;  % 200 ms stimulus display time
tRTLimit  = 2.000;  % 2000ms response time limit
tITI      = 0.500;  % 500 ms intertrial interval
tFeedback = 0.400;  % 400 ms auditory feedback
freqCorrect = 600;  % 600 Hz tone for correct response
freqIncorrect = 300; % 300 Hz beep for incorrect & no (too-late) response
keymap.l = 'h'; keymap.r = 'k';  % left and right response keys
keymap.quit = 'q';  % q=quits.
% keymap.magic = 'z';  % z="zoom!", mark as correct, dev-only!! (not implemented)
meanEqualCode = 'x';  % when neither 'l' nor 'r' is right because means are equal!
maxTrials = 42;  % upto 42 trials per block!
numTrials = min([ (length(trials)-doneTrials), maxTrials]);  % trials to do this time
if numTrials==0
  fprintf(1,'\nDone with condition %s.\nPlease inform the experimenter.\n',cond)
  return
end

% special subject code for DEBUG = dbg
if strcmp(subjCode,'dbg')  
  disp('DEBUG MODE!')
  tDisplay  = 5;   % show display for really long time
  numTrials =  3;
end

%% Input/Output Device Settings
% Display / Screen stuff
ResInfo             = Screen('Resolution',0);
ScrRes              = [ResInfo.width ResInfo.height];
BGCol               = black;        % backgroundcolor
TextColors          = {white};
KbName('UnifyKeyNames');
%% Feedback tones
InitializePsychSound;
audiohandle = PsychPortAudio('Open');
toneCorrect   = MakeTone(audiohandle, freqCorrect, tFeedback);       % pleasant tone
toneIncorrect = MakeTone(audiohandle, freqIncorrect, tFeedback);     % annoying tone
toneToolate   = MakeTone(audiohandle, freqIncorrect, tFeedback/2, 2);% fast, double annoying tone

try
HideCursor;
% Initialize Screen
WhichScreen=max(Screen('Screens'));
shutdown.oldVDLevel = Screen('Preference', 'VisualDebugLevel', 2);
shutdown.oldVerbosity = Screen('Preference', 'Verbosity', 1);
shutdown.oldSkipSyncValue = Screen('Preference', 'SkipSyncTests', 1);
[w, winRect] = Screen('OpenWindow',WhichScreen,BGCol);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[xCen, yCen] = RectCenter(winRect);

%% Open a half-size offscreen window for pre-drawing Left & Right stimuli
HalfScrRes = [ScrRes(1)/2 ScrRes(2)];  % half-screens split along horizontal side
woff1 = Screen('OpenOffScreenWindow',w,[0 0 0 0], [0 0 HalfScrRes]);
woff2 = Screen('OpenOffScreenWindow',w,[0 0 0 0], [0 0 HalfScrRes]);

% Display reminder of instructions (need to have shown demo already)
% Make them press left key, then right key; that will call the KbCheck/KbName MEX files!
equneq_instructions(w, keymap.l, keymap.r);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main trial loop
for i = doneTrials+1 : doneTrials+numTrials

    % Draw fixation to indicate the start of the trial
    Screen('FillRect', w, black);
    DrawFixation(w, fixationLength, xCen, yCen);
    [~, tFixOnset] = Screen('Flip', w,[], 1);   % dontClear =1  %% Show fixation, mark its onset time

    % Prepare stimuli on our offscreen half-windows
    Screen('FillRect', woff1, black); 
    Screen('FillRect', woff2, black); 
    Screen('DrawDots',woff1,trials(i).Lcirs(:,1:2)',trials(i).Lcirs(:,3),white,[],1); % 1=cir, 2=circ++
    Screen('DrawDots',woff1,trials(i).Lcirs(:,1:2)',trials(i).Lcirs(:,3)-10,black,[],1); % for outline
    Screen('DrawDots',woff2,trials(i).Rcirs(:,1:2)',trials(i).Rcirs(:,3),white,[],1); 
    Screen('DrawDots',woff2,trials(i).Rcirs(:,1:2)',trials(i).Rcirs(:,3)-10,black,[],1); % for outline
    PlaceHalfWindowsLR(w,woff1,woff2,ScrRes);  % Put the stimuli on the window
    DrawFixation(w, fixationLength, xCen, yCen);  % Add fixation cross last
    % Wait til the end of fixation period; then display stimuli. Mark stimulus onset time.
    [~, tStimulusOnset] = Screen('Flip', w, tFixOnset+tFixation);   %%%%%%%%% <========== show stimuli!

    % curImage=Screen('GetImage', w);  % store current window for later usage 
    % fname = ['screenshotOUTLINE' num2str(i) '.jpg'];
    % imwrite(curImage,fname,'jpg');

    %%% Stimulus offset: Blank screen until response
    Screen('FillRect', w, black);
    [~, tStimulusOffset] = Screen('Flip', w, tStimulusOnset+tDisplay, 1);   % dontClear =1

    % Get 2AFC response keypress. Keep this clean to have tight confidence on RT
    keyIsDown = 0;
    while (GetSecs-tStimulusOffset < tRTLimit) && ~keyIsDown  % exits at 1st keypress, or hitting time limit
      [keyIsDown, tKeypress, keyCode] = KbCheck;
      if keyIsDown
	% quickly process keypress
	key = KbName(keyCode);
	if strcmp(key, keymap.quit)  % quits experiment gracefully (doesn't save though!)
	  disp('quit from response period')
	  ShutdownNicely(shutdown);
	  return
	else    % record key pressed and RT
	  choices{i} = key;
	  afcL(i)    = strcmp(key, keymap.l); % did they press L?
	  RTs(i)     = tKeypress - tStimulusOnset;
	end  % if strcmp(key...)
      end  % if keyisdown response period
    end %%% while (kbcheck loop)
    % Note: if subj took too long, choices{i} will be an empty cell and RTs(i) will be NaN

    %% Intertrial / Feedback period: 
    %% Do post-trial tasks (saving to disk, auditory feedback, etc)
    interTrialStart = tic;     % Mark the start of the intertrial period
    postTrialStuffDoneYet = 0;
    while toc(interTrialStart) < tITI       %% Wait a defined amount of time.
      [keyIsDown, ~, keyCode]= KbCheck;   % checking for quit requests during ITI
      if keyIsDown
	key = KbName(keyCode);
	if strcmp(key, keymap.quit)  % quits experiment gracefully (doesn't save though!)
	  disp('quit from intertrial interval')
	  ShutdownNicely(shutdown);
	  return
	end
      end  % if keyisdown ITI

      if ~postTrialStuffDoneYet
	% 1. Give real-time feedback in the form of sounds, record accuracy data
	if isnan(RTs(i))   % didn't respond in time  [we're characterizing response]
	  PsychPortAudio('FillBuffer', audiohandle,toneToolate);
	elseif strcmp( trials(i).trialRightAnswers, meanEqualCode );  % trial has no right/wrong ans
	  % the means are actually equal. flip a coin to call it right or wrong
	  % note: accuracy is a lie here, but it saves WHAT WE TOLD THE SUBJECT!!
	  % FIXME: ideally, this would be standard for all subjects!!
	  if round(rand)  % coinflip = 1; call it right
            PsychPortAudio('FillBuffer', audiohandle,toneCorrect);
            ACCs(i) = 1;
	  else  % call it wrong
	    PsychPortAudio('FillBuffer', audiohandle,toneIncorrect);
            ACCs(i) = 0;
	  end  % if coin flip
	elseif  strcmp(choices{i}, keymap.l) || strcmp(choices{i}, keymap.r)  % hit a valid key
	  if strcmp(choices{i}, keymap.(trials(i).trialRightAnswers)) % response was right
	    PsychPortAudio('FillBuffer', audiohandle,toneCorrect);
            ACCs(i) = 1;
	  else      % response was the wrong side
	    PsychPortAudio('FillBuffer', audiohandle,toneIncorrect);
            ACCs(i) = 0;
	  end  %-- if response was right
	else  % hit an invalid key.  Note: ACCs(i) should stay NaN as initialized
	  PsychPortAudio('FillBuffer', audiohandle,toneToolate);  % FIXME: giving too-late feedback ok?
	end  %-- isnan  (characterize response)
	PsychPortAudio('Start',audiohandle);  % play feedback (program keeps going, i think)

            % 3. Record data for experimental parameters in .mat
            expdata.trial(i) = i;
            expdata.veridical(i) = trials(i).trialRightAnswers;
            expdata.RTs(i) = RTs(i);
            expdata.choices{i} = choices{i};
	    expdata.afcL(i) = afcL(i);
            expdata.ACCs(i) = ACCs(i);
            expdata.trialType(i) = trials(i).trialType;
	    expdata.Lmean(i) = trials(i).Lmean;
	    expdata.Rmean(i) = trials(i).Rmean;
            save(datafile, 'expdata');  

            postTrialStuffDoneYet = 1; % all intertrial business is finished
        end  %% doing post-trial stuff

    end  %% waiting in ITI
end  %% main trial loop

 
% Inform subjects that experiment is over, shutdown everything
endDisplay = ['The block is over.\n\n'...
                'Please rest now, and restart when ready.'];
DrawFormattedText(w, endDisplay, 'center', 'center', white);
Screen('Flip', w);
WaitSecs(2);
ShutdownNicely(shutdown);  % Close the program

catch ME
  display('Caught error; quitting gracefully.')
  ShutdownNicely(shutdown)
  rethrow(ME);
end
