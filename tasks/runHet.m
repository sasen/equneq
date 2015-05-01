function runHet(ExpMode)
% RUNHET   Run heterogeneous ensembles experiment
%   Spring 2015 // Comments to Sasen Cain sasen@ucsd.edu
%   ExpMode: 0 = test mode, 1 = real experiment mode

%% Experiment description
%
% Two ensembles of filled circles, to L and R of fixation. 
% Keypress 2-AFC on which side has greater mean diameter.
% Sets may have equal or unequal numbers of circles.

%% Function Settings

  % nargin = 0;

switch nargin,
    case 0
  ExpMode        =  0; % 0 = test mode, 1 = real experiment mode
  Screen('Preference', 'Verbosity', 1)
end

%% Screen Settings
  Dist2Scr            =   720;            % (mm)
  HoriScrDist         =   400;            % (mm)
  ScrHz               =   60;             % framerate of screen (frames/second)
  ScrNum              =   0;              % SS: changed from 2 due to InitializeScreens crash
  BGCol               =   [0 0 0];        % backgroundcolor
  TextColors          =   {[255 255 255]};


if ispc %% probably stimulus computer  %%% SS FIXME is this even true?
    % Get the subject number & block number
    subjNum = input('\n Enter subject #:','s');
    currBlock = str2double(input('\n Block # (0=Prac):', 's')); %% SS FIXME
%    Priority(2);  %% SS FIXME is this still needed?
else  %% definitely not stimulus computer
    subjNum = '888';    
    currBlock = 0;
end

%Create a directory for this subject's data
dirname=['het',subjNum];
mkdir(dirname);
pathdata=strcat(pwd,filesep,'DATA',filesep,dirname,filesep); 

%%% Eventually will generate from predetermined stimulus parameter file
%   This should be in a try-catch, and the error should say what it can't find or load or whatever.
% if exist(calibFile,'file')
%  load(calibFile);
%end

% set number of trials and blocks
numTrials = 5;

Lcircs = [200 100 10; 200 400 20; 500 325 5];
Rcircs = [200 100 10; 200 400 20; 500 325 5];


try
HideCursor;
% Initialize Screen
WhichScreen=max(Screen('Screens'));
oldVDLevel = Screen('Preference', 'VisualDebugLevel', 2);
[w, winRect] = Screen('OpenWindow',WhichScreen,[0 0 0]); %,[0 0 600 400]);
[xCen, yCen] = RectCenter(winRect);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%%%%%%%%%%%%%%%%%%%%%%%
% Stimulus parameters %
%%%%%%%%%%%%%%%%%%%%%%%
% define colors
black = [0 0 0];
white = [255 255 255];   
% length of lines in fixation cross
fixationLength = 10;
% Positions of each object
numItems = 3;  % how many objects on each trial?

%%%%%%%% Predraw Shapes Offscreen
% For orientation task, make a white shape offscreen. Later use DrawTexture 
%   to rotate & color it. green 45deg @ pos1 :
%   Screen('DrawTexture',w,wOff,[],CenterRectOnPoint(woffrect,xPos(1),yPos(1)),45,[],[],green);
[wOff, woffrect] = Screen('OpenOffscreenWindow',w, [0 0 0], [0 0 shapeRadius*6 shapeRadius*2]);
Screen('FillOval', wOff, [255 255 255]); %%% circle

%%%%%%%%%%%%%%%%%%%%%%
%    Exp. Variables  %
%%%%%%%%%%%%%%%%%%%%%%
%Chime sound
chime = MakeBeep(600,.2);
wrongChime = MakeBeep(300,.2);

midPoint = numTrials/2;  % midpoint of total trials


%%%%%%%%%%%%%%%%%%%%%%
%   Timing variables %
%%%%%%%%%%%%%%%%%%%%%%
tFixation = 0.500;  % 500 ms fixation cross display
tDisplay  = 0.200;  % 200ms stimulus display time

%%%%%%%%%%%%%%%%%%%%%%%%%
% Other pre-trial stuff %
%%%%%%%%%%%%%%%%%%%%%%%%%
% Save experiment parameters for this block
%save(strcat(pathdata,subjNum,'_Block',num2str(currBlock),'.mat'),'-mat');

% Preallocate response variables
choice = zeros(numTrials,1);  % 2AFC: Left = 1, Right = 2

% Display Instructions
equneq_instructions(currBlock, w);
% practice instructions, do practice trials, then expt instructions, expt trial blocks

% Main trial loop
for i=1:numTrials

    % For each trial, set the following paramters to zero
    % Subject reached somwhere?
    reachedTo = 0;
    % Stop looking for a reach movement?
    exit = 0;

    % Draw fixation to indicate the start of the trial
    Screen('FillRect', w, black);
    Screen('DrawLine', w, white, xCen - fixationLength, yCen, xCen + fixationLength, yCen);
    Screen('DrawLine', w, white, xCen, yCen - fixationLength, xCen, yCen + fixationLength); 
    Screen('Flip', w,[], 1);   % dontClear =1
    
    % Draw target + distractors   %%%%%%%% <======== DRAW  TRIAL OBJECTS!
    for j = 1:numItems
        if (j == targetLocation(i))  % draw target
    	    Screen('DrawTexture', w, wOff, [], CenterRectOnPoint(woffrect, xLoc(j), yLoc(j)), targetOrient(i), [], [], white);
        else
    	    Screen('DrawTexture', w, wOff, [], CenterRectOnPoint(woffrect, xLoc(j), yLoc(j)), distractorOrient(i), [], [], colors(lureColor(i),:));
        end
    end

    Screen('Flip', w);   %%%%%%%%% <========== show the stimulus!
    % Mark the time when the display went up
    stimulus_onset_time = tic;    

% %%%%%%%%%%%%%%%%%%%%%
% curImage=Screen('GetImage', w);  % store current window for later usage 
% fname = [expName num2str(i) '.jpg'];
% imwrite(curImage,fname,'jpg');

    WaitSecs(tDelay);  % SS FIXME do this properly!

    Screen('FillRect', w, black);
    Screen('DrawLine', w, white, xCen - fixationLength, yCen, xCen + fixationLength, yCen);
    Screen('DrawLine', w, white, xCen, yCen - fixationLength, xCen, yCen + fixationLength); 
    Screen('Flip', w,[], 1);   % dontClear =1
  
    rightAnswer = 2;
   
    while (toc(stimulus_onset_time) < RTDeadline && ~exit)
      % Look for keypresses
      [keyIsDown, secs, keyCode]= KbCheck;
      key = KbName(keyCode);
      % z counts as a correct answer (target location number also works)
      if ((keyIsDown) && ( ((strcmp(key(1),'z'))) || ((strcmp(key(1),rightAnswer))) ))
	reachedTo = targetLocation(i);
	timeElapsed = toc(stimulus_onset_time);   
	exit = 1;
	% q quits experiment gracefully
      elseif ((keyIsDown)&& strcmp(key(1),'q'))
	ShowCursor;
	Screen('Preference', 'VisualDebugLevel', oldVDLevel);
	Screen('CloseAll');
	Snd('Close');
	return;
      elseif (keyIsDown)  %% hit the wrong button
	reachedTo = targetLocation(i) + 1;
	timeElapsed = toc(stimulus_onset_time);
	exit = 1;
      end
    end
        	        
    % how much time since stimulus onset?
    SOT_data = [SOT_data;toc(stimulus_onset_time)];
    
    end  %% end "stimulus is up, track until RT deadline"

    %% End loop actions:
    % Record movement for an extra "extraMeasurementTime" seconds to get velocity profiles
    trialLoopEnd = tic;     % mark the time when the end loop begins
    end

    %% Intertrial period: 
    %% Do post-trial tasks (saving to disk, auditory feedback, etc)
    %% Wait a defined amount of time.
    interTrialStart = tic;     % Mark the start of the intertrial period
    postTrialStuffDoneYet = 0;
    while toc(interTrialStart) < iti
        % q quits experiment gracefully
        [keyIsDown, ~, keyCode]= KbCheck;
        key = KbName(keyCode);
        if ((keyIsDown)&& strcmp(key(1),'q'))
            ShowCursor;
            Screen('Preference', 'VisualDebugLevel', oldVDLevel);
            Screen('CloseAll');
            Snd('Close');
            return;
        end

        if ~postTrialStuffDoneYet
            if (currBlock==0) || (currBlock==10)
                Screen('Flip',w);
            else            
                % 1. Put up a blank black screen
                Screen('FillRect', w, black);
                Screen('Flip',w);
            end

            % 2. Give real-time feedback in the form of sounds, record accuracy data

            if (reachedTo > 0)
                if reachedTo == targetLocation(i)
                    acc(i) = 1;
                    Snd('Play',chime);                       
                else
                    acc(i) = 0;
                    Snd('Play',wrongChime);
                end
            else % If they never reached: analyze later & play double-beep
                timeElapsed = 0;  % set timeelapsed as 0 for later analysis
                acc(i) = 0;
                % play a double beep to indicate time ran out
                if reachedTo == 0
%                    Snd('Play',wrongChime);
%                    WaitSecs(.3);
%                    Snd('Play',wrongChime);
                end                    
            end

            % Write this trial's data to exp. data file 
            dlmwrite(strcat(pathdata,subjNum,'_','TestBlock',num2str(currBlock),'.txt'),...
                [ i, reachedTo,timeElapsed, acc(i), targetLocation(i), trialType(i), lureColor(i), lureLocation(i), targetOrient(i), distractorOrient(i), graspCondition],'-append', 'roffset', [],'delimiter', '\t');

            %Record data for experimental parameters in .mat
            expdata.block(i) = currBlock;
            expdata.timeElapsed(i) = timeElapsed;
            expdata.reachedTo(i) = reachedTo;
            expdata.accuracy(i) = acc(i);
            expdata.trialType(i) = trialType(i);
            save(strcat(pathdata,subjNum,'_TestBlock', num2str(currBlock),'_MATDATA'), 'expdata');  
            postTrialStuffDoneYet = 1; % all intertrial business is finished
        end  %% doing post-trial stuff
    end  %% waiting in ITI

end  %% end "for i in 1:numTrials"

 
% Inform subjects that experiment is over, shutdown tracker
endDisplay = ['The block is over.\n\n'...
                'Please inform the experimenter.'];
DrawFormattedText(w, endDisplay, 'center', 'center', white);
Screen('Flip', w);

WaitSecs(5);

% Close the program
ShowCursor;
Screen('Preference', 'VisualDebugLevel', oldVDLevel);
Priority(0);
Screen('CloseAll');
Snd('Close');

catch ME
    Screen('CloseAll');
    Snd('Close');
    ShowCursor;
    Priority(0);
    rethrow(ME);
end
    
end