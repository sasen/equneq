function [] = PlaceHalfWindowsLR(window,onehalf,otherhalf,ScrRes)
%function [] = PlaceHalfWindowsLR(window,onehalf,otherhalf,ScrRes)
% Tile two offscreen half-windows next to each other.
%    window: destination (double-wide) PsychToolbox window
%    onehalf: lefthand texture to draw (on a pointer to offscreen window)
%    otherhalf: righthand texture to draw (on a pointer to offscreen window)
%    ScrRes: the full screen resolution (for 'window')
% Note: PsychToolbox screens/windows must already be opened and drawn upon.
% See also: DrawMirrored, in the whac repository.

assert(nargin==4,'PlaceHalfWindowsLR: Need 4 arguments, got %d.\n',nargin)
Screen('DrawTexture',window,onehalf,[], [0 0 ScrRes(1)/2 ScrRes(2)], 0, 0); % filterMode=0 for uncorr noise!
Screen('DrawTexture',window,otherhalf,[], [ScrRes(1)/2 0 ScrRes(1) ScrRes(2)], 0, 0);
