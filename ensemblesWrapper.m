function ensemblesWrapper(subjCode)

if nargin<1,
    % Subject info
    prompt={'Participant code:'};
    def={'999'};
    title='Input Participant Code';
    lineNo=1;
    userinput=inputdlg(prompt,title,lineNo,def);
    subjCode=userinput{1};
end

assert(length(subjCode)==3,'subjCode must be 3 characters long.')
assert(ischar(subjCode),'Put that subjCode in single quotes!')

% focus to the command window
commandwindow;

% get into the correct folder
cd 'C:\Users\Seated4\Desktop\Matt Experiments\ensembles\tasks'

% make sure helper files are in the path
addpath(['..' filesep 'helpers' filesep]);

%% practice
% terminated by experimenter
pracCode = ['9' subjCode(2:3)];
runHet('m',pracCode);

%% experiment
% 408 equal count trials across 10 blocks
for i=1:10,
runHet('s',subjCode);

[keyIsDown,~,keyCode]=KbCheck;
if keyIsDown
    if strcmpi(KbName(keyCode),'q'),
        return;
    end
end
end

% 408 unequal count trials across 10 blocks
for i=1:10,
runHet('d',subjCode);

[keyIsDown,~,keyCode]=KbCheck;
if keyIsDown
    if strcmpi(KbName(keyCode),'q'),
        return;
    end
end
end

% 816 mixed trials across 20 blocks
for i=1:20,
runHet('m',subjCode);

[keyIsDown,~,keyCode]=KbCheck;
if keyIsDown
    if strcmpi(KbName(keyCode),'q'),
        return;
    end
end
end

%% End of experiment notice
WhichScreen=max(Screen('Screens'));
shutdown.oldVDLevel = Screen('Preference', 'VisualDebugLevel', 2);
shutdown.oldVerbosity = Screen('Preference', 'Verbosity', 1);
shutdown.oldSkipSyncValue = Screen('Preference', 'SkipSyncTests', 1);
[w, ~] = Screen('OpenWindow',WhichScreen,[0 0 0]);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


instText = ['You have reached the end of this part of the experiment!\n\n',...
    'Please tell the experimenter that you have finished'];
Screen('FillRect', w, [0 0 0]); % instruction screen background black
Screen('TextSize', w, 25);
DrawFormattedText(w, instText, 'Center', 'Center', [255 255 255]);
Screen('Flip', w);  % display instructions

WaitSecs(2);
KbWait([],2);

ShutdownNicely(shutdown);