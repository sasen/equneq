function [] = DrawFixation(window, armLength, x, y, rgb)
% function [] = DrawFixation(window, armLength, x, y, rgb)
% Draw fixation cross (x) and LR-split line to window.
%    window: destination PsychToolbox window (with background already drawn)
%    armLength: size in pixels
%    x, y: position of the cross's center on window, in pixels
%    rgb: color of cross, 3 or 4 element vector -- [r g b] or [r g b a]
%         OPTIONAL, default is white: [255 255 255]

if nargin == 4
  rgb = [255 255 255]; % default to white cross
end

%Screen('DrawLine', window, rgb, x - armLength, y, x + armLength, y);
Screen('DrawLine', window, rgb, x - armLength, y+armLength, x + armLength, y-armLength);
%Screen('DrawLine', window, rgb, x, y - armLength, x, y + armLength);
Screen('DrawLine', window, rgb, x-armLength, y - armLength, x+armLength, y + armLength);
Screen('DrawLine', window, rgb, x, 1, x, 800);
