function equneq_instructions(w,keyl,keyr)
% EQUNEQ_INSTRUCTIONS  Display instructions for ensembles task
%   w (int): usable PsychToolbox window

% blank screen
Screen('FillRect', w, [0 0 0]);
Screen('Flip', w);

instText = ['Choose which side has LARGER mean size.\n\n' ...
	    'Press  h  for left.             Press  k  for right.\n\n' ...
	    'Look at the cross in the midddle.\n\n\n\n' ...
	    'If you respond correctly, you will hear a HIGH beep. \n\n'...
	    'If you respond incorrectly, you will hear a LOW beep. \n\n\n'...
	    'If you do not respond in time, you will hear DOUBLE LOW beeps.\n\n' ...
	    'If you press anything than h or k, you will hear DOUBLE LOW beeps.\n\n\n\n' ...
	    'Each block takes a few minutes, and contains about 40 trials.\n' ...
	    'To begin, press h, and then press k.' ];

Screen('FillRect', w, [0 0 0]); % instruction screen background black
Screen('TextSize', w, 25);
DrawFormattedText(w, instText, 'Center', 'Center', [255 255 255]);
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

