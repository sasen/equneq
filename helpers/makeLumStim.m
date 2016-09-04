stimfname = 'allStimuli123_6.mat';
load(fullfile('tasks',stimfname),'sTr','dTr','mTr');
lumfpath = fullfile('tasks',['lum' stimfname])   % will write luminances to this file

sLum = generateLuminances(sTr);
dLum = generateLuminances(dTr);
mLum = generateLuminances(mTr);
save(lumfpath, 'sLum','dLum','mLum');
