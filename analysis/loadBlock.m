clear all;
datafile = '../DATA/het888/888_TestBlock0_MATDATA.mat';
load(datafile)

varnames = fieldnames(expdata);
for var = 1:length(varnames)
  vname = varnames{var};
  thisval = getfield(expdata,vname);
  assignin('base',vname,thisval);
end
%cellstr(veridical')

gotWrong = []; gotRight = [];
for tr = 1:length(Lmean)
  truth(tr) = strcmp(veridical(tr),'l');
  if ACCs(tr) == 0
    gotWrong(end+1,:) = [tr Lmean(tr) Rmean(tr) Lmean(tr)/Rmean(tr)];
  elseif ACCs(tr) == 1
    gotRight(end+1,:) = [tr Lmean(tr) Rmean(tr) Lmean(tr)/Rmean(tr)];
  end
end

ratrange = minmax(Lmean./Rmean);
histbins = linspace(ratrange(1),ratrange(2),20)';
histRight = histc(gotRight(:,end),histbins);
histWrong = histc(gotWrong(:,end),histbins);

bar(histbins,[histRight histWrong],'histc')
