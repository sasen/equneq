function runHet(cond)
% RUNHET   Run heterogeneous ensembles experiment
%   Spring 2015 // Comments to Sasen Cain sasen@ucsd.edu
%   cond (char) : condition 's', 'd', 'm' for same, different, or mixed trials
%% Experiment description
%
% Two ensembles of filled circles, to L and R of fixation. 
% Keypress 2-AFC on which side has greater mean diameter.
% Sets may have equal or unequal numbers of circles.
assert(nargin==1,'Exactly one argument, the condition code, is required.')

stimfile = 'type2_66_77.mat';
%stimfile = 'all_60_65.mat';
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
numTrials = length(trials);

if ispc %% probably stimulus computer  %%% SS FIXME is this even true?
    % Get the subject number & block number
    subjNum = input('\n Enter subject #:','s');
    currBlock = str2double(input('\n Block # (0=Prac):', 's')); %% SS FIXME
%    Priority(2);  %% SS FIXME is this still needed?
else  %% definitely not stimulus computer
    subjNum = '888';    
    currBlock = 0;
    Screen('Preference', 'Verbosity', 1)
end

%Create a directory for this subject's data
dirname=['het',subjNum];
pathdata=strcat(pwd,filesep,'..',filesep,'DATA',filesep,dirname,filesep); 
mkdir(pathdata);


%%%%%%%%%%%%%%%%%%%%%%%
% Stimulus parameters %
%%%%%%%%%%%%%%%%%%%%%%%
black = [  0   0   0];
white = [255 255 255];   
fixationLength = 10;  % length of lines in fixation cross
tFixation = 0.500;  % 500 ms fixation cross display
tDisplay  = 5.200;  % 200 ms stimulus display time
tRTLimit  = 2.000;  % 2000ms response time limit
tITI      = 0.500;  % 500 ms intertrial interval
tFeedback = 0.400;  % 400 ms auditory feedback
freqCorrect = 600;  % 600 Hz tone for correct response
freqIncorrect = 300; % 300 Hz beep for incorrect & no (too-late) response
keymap.l = 'h'; keymap.r = 'k';  % left and right response keys
keymap.quit = 'q';  % q=quits.
% keymap.magic = 'z';  % z="zoom!", mark as correct, dev-only!! (not implemented)
stimGenerationFile = 'allStimuli.txt';
blocks = 1;
%%% Eventually will generate from predetermined stimulus parameter file
%   This should be in a try-catch, and the error should say what it can't find or load or whatever.
if exist(stimGenerationFile,'file')
  load(stimGenerationFile);
else
  numTrials = 5;
  Lcirs = [200 100 30; 200 400 40; 500 325 25; 100 500 50];
  Rcirs = [200 100 70; 200 400 100; 500 325 50];
  trialRightAnswers = 'lrlrl'; % fake 5 trials
end
% FIXME positions non-random; on a grid
% 3x2 equally spaced for 6 items. 3x4 for 12 items

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
shutdown.oldSkipSyncValue = Screen('Preference', 'SkipSyncTests', 1);
[w, winRect] = Screen('OpenWindow',WhichScreen,BGCol);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[xCen, yCen] = RectCenter(winRect);

%% Open a half-size offscreen window for pre-drawing Left & Right stimuli
HalfScrRes = [ScrRes(1)/2 ScrRes(2)];  % half-screens split along horizontal side
woff1 = Screen('OpenOffScreenWindow',w,[0 0 0 0], [0 0 HalfScrRes]);
woff2 = Screen('OpenOffScreenWindow',w,[0 0 0 0], [0 0 HalfScrRes]);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Other pre-trial stuff %
%%%%%%%%%%%%%%%%%%%%%%%%%

% FIXME should we be able to restart blocks?
% avoid overwriting! use time string in filename
datafile = strcat(pathdata,cond,num2str(currBlock),'_',subjNum,'_time',datestr(now,'HH_MM_SS'));

% Preallocate 2AFC task response variables
%% FIXME numTrials is BS
numTrials = 20;
choices = cell(numTrials,1);   % record ANY keypress
RTs     = nan(numTrials,1);    % reaction time (ANY button press) in ms since stimulus onset
ACCs    = nan(numTrials,1);    % 2AFC: accuracy, Correct = 1, Incorrect = 0, No response/wrong key = NaN.

% Display Instructions
%equneq_instructions(currBlock, w);
% practice instructions, do practice trials, then expt instructions, expt trial blocks
% Make them press a trial to start; that will call the KbCheck/KbName MEX files!

% Main trial loop
for i=1: numTrials

    % Draw fixation to indicate the start of the trial
    Screen('FillRect', w, black);
    DrawFixation(w, fixationLength, xCen, yCen);
    [~, tFixOnset] = Screen('Flip', w,[], 1);   % dontClear =1  %% Show fixation, mark its onset time

    % Prepare stimuli on our offscreen half-windows
    Screen('FillRect', woff1, black); 
    Screen('FillRect', woff2, black); 
    Screen('DrawDots',woff1,trials(i).Lcirs(:,1:2)',trials(i).Lcirs(:,3),white,[],1); % 1=cir, 2=circ++
    Screen('DrawDots',woff2,trials(i).Rcirs(:,1:2)',trials(i).Rcirs(:,3),white,[],1); 
    PlaceHalfWindowsLR(w,woff1,woff2,ScrRes);  % Put the stimuli on the window
    DrawFixation(w, fixationLength, xCen, yCen);  % Add fixation cross last
    % Wait til the end of fixation period; then display stimuli. Mark stimulus onset time.
    [~, tStimulusOnset] = Screen('Flip', w, tFixOnset+tFixation);   %%%%%%%%% <========== show stimuli!

    % curImage=Screen('GetImage', w);  % store current window for later usage 
    % fname = [expName num2str(i) '.jpg'];
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
	    %% FIXME: maybe these should be preallocated!!
            expdata.block(i) = currBlock;
            expdata.trial(i) = i;
            expdata.veridical(i) = trials(i).trialRightAnswers;
            expdata.RTs(i) = RTs(i);
            expdata.choices{i} = choices{i};
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
                'Please inform the experimenter.'];
DrawFormattedText(w, endDisplay, 'center', 'center', white);
Screen('Flip', w);
WaitSecs(2);
ShutdownNicely(shutdown);  % Close the program

catch ME
  display('Caught error; quitting gracefully.')
  ShutdownNicely(shutdown)
  rethrow(ME);
end
