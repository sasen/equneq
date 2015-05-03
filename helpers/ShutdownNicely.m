function [] = ShutdownNicely(shutdown)
% [] = ShutdownNicely(shutdown)
% ShutdownNicely  Exit the Psychtoolbox experiment with some grace.
%   shutdown: struct with a few parameters to restore, handles to close, etc.
%     -- oldVDLevel: Screen VisualDebugLevel
%     -- oldSkipSyncValue: Screen SkipSyncTests
  ShowCursor;
  Screen('Preference', 'VisualDebugLevel', shutdown.oldVDLevel);
  Screen('Preference', 'SkipSyncTests', shutdown.oldSkipSyncValue);
  Screen('CloseAll');
  PsychPortAudio('Close');
  Priority(0);
