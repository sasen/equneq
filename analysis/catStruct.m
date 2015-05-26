function s = catStruct(s1,s2)
% function s = catStruct(s1,s2)
% Concatenate structs s1 and s2 into s.
% I can't believe I had to write this. Please tell me if there's a better way!!!!
fnames = fieldnames(s1);
nfields = numel(fnames);

for ff = 1:nfields
  fieldn = fnames{ff};
  s.(fieldn) = [s1.(fieldn) s2.(fieldn)];
end
