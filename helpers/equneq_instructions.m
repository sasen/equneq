function equneq_instructions(w,keyl,keyr,BGCol,TxtCol)
% EQUNEQ_INSTRUCTIONS  Display instructions for ensembles task
% equneq_instructions(w,keyl,keyr,BGCol,TxtCol)
%   w (int): usable PsychToolbox window
%   keyl, keyr (char): left/right key, eg 'h' and 'k' 
%   BGCol (int(3)): background color in [r g b] 0-255
%   TxtCol: same idea, for text color

% blank screen
Screen('FillRect', w, BGCol);
Screen('Flip', w);

instText = ['Choose which side has LARGER mean size.\n\n' ...
	    sprintf('Press  %s  for left.             Press  %s  for right.\n\n',keyl,keyr) ...
	    'Look at the cross in the midddle.\n\n\n\n' ...
	    'If you respond correctly, you will hear a HIGH beep. \n\n'...
	    'If you respond incorrectly, you will hear a LOW beep. \n\n\n'...
	    'If you do not respond in time, you will hear DOUBLE LOW beeps.\n\n' ...
	    sprintf('If you press anything than %s or %s, you will hear DOUBLE LOW beeps.\n\n\n\n',keyl,keyr) ...
	    'Each block takes a few minutes, and contains about 40 trials.\n' ...
	    sprintf('To begin, press %s, and then press %s.',keyl,keyr) ];

Screen('FillRect', w, BGCol); % instruction screen background
Screen('TextSize', w, 25);
DrawFormattedText(w, instText, 'Center', 'Center', TxtCol);
Screen('Flip', w);  % display instructions

nextKey = keyl; % first make them press left key
while strcmp(nextKey,keyl)
  [keyIsDown, ~, keyCode] = KbCheck;
  if keyIsDown
    key = KbName(keyCode);
    if strcmp(key, nextKey) 
      nextKey = keyr;  % now make them press right key
    end
  else 
    WaitSecs(0.01); % 10ms
  end % if keydown
end

while strcmp(nextKey,keyr)
  [keyIsDown, ~, keyCode] = KbCheck;
  if keyIsDown
    key = KbName(keyCode);
    if strcmp(key, nextKey) 
      nextKey = ' '; % ready to go!
    end
  else 
    WaitSecs(0.01); % 10ms
  end % if keydown
end

