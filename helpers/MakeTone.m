function buffertone = MakeTone(PAhandle,freq,tMax,repetitions)
% function buffertone = MakeTone(PAhandle,freq,tMax,repetitions)
% MakeTone  Creates a sinusoidal tone in a PsychPortAudio data-buffer
%   PAhandle: open PortAudio handle
%   freq: for the tone (Hz)
%   tMax: approx how long to produce tone (s), per repetition
%   repetitions: # of times to repeat the tone (optional; default=1)
%   buffertone: a buffer with the tone pre-loaded. 
% Note: The sampling rate is 44.1kHz. Buffer will be stereo.
% Note: I think buffers:textures::PsychPortAudio:Screen, and FillBuffer:DrawTexture
% Note: Don't use this for tight audio timing! Playing 3/4 of tMax so repeats are heard
if nargin < 4
  repetitions = 1;
end
sr = 44100;    % sampling rate (Hz)
dt = 1/sr;  % timestep (s)

t = repmat([ [0:dt:0.75*tMax] zeros(1,tMax*sr/4) ], [1 repetitions]);  % make a time axis (repeating as requested)
tone = cos(2*pi*freq * t);   % compute a cos function over the interval t at frequency 'freq'
buffertone = PsychPortAudio('CreateBuffer', PAhandle, [tone;tone]);  % in stereo
