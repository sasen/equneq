function [pgmdir, tr] = convertScreenshotsJpgToPgm(blocktype, trMax)
% Helper for texture synthesis pipelines, which use pgm format
% [pgmdir, tr] = convertScreenshotsJpgToPgm(blocktype, trMax)
% blocktype = 's' or 'd' or 'm'
% trMax = 408, or 816 for m... can do fewer for debug, but starts at 1!
%----
% pgmdir = string of where the new files are located
% tr = trial number for screenshot being worked on (starting at 1), for debug
% FYI, jpgdir = '~/Dropbox/ucsd/projects/fyp/expts/stimuli_tufts/ensemble_screenshots/'

jpgdir = '~/Dropbox/ucsd/projects/fyp/expts/stimuli_tufts/ensemble_screenshots/'
pgmdir = fullfile(jpgdir, 'pgm_format');
mkdir(pgmdir);

%% go through trial screenshots
for tr = 1:trMax
  fnamestem = strjoin( {'screenshot', blocktype, num2str(tr)}, '_' );
  jpgname = [fullfile(jpgdir, fnamestem) '.jpg'];
  pgmname = [fullfile(pgmdir, fnamestem) '.pgm'];
  imwrite(imread(jpgname), pgmname);
end  % going through screenshots 