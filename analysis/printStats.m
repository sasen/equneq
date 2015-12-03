function printStats(st)
n = numel(st.p);
if isfield(st,'conds')
  condnames = {'  6/6 B','12/12 B',' 6/12 B',' 12/6 B','  6/6 M','12/12 M',' 6/12 M',' 12/6 M'};
else
  st.conds = 1:n;
  switch n
   case 2
    condnames = {'avg Equal','diff Uneq'};
   case 4
    condnames = {'6s-12s B','EQ--0  B','6s-12s M','EQ--0  M'};
   case 6
    condnames = {'sigEq  B','sigUn  B','sigEvU B','sigEq  M','sigUn  M','sigEvU M'};
   case 10
    condnames = {'6/12-EQ B','12/6-EQ B','AsymPSE B','OS-UNEQ B','OS-AREA B','6/12-EQ M','12/6-EQ M','AsymPSE M','OS-UNEQ M','OS-AREA M'};
  end
end
for i = 1:n 
  condstr = condnames{st.conds(i)};
  fprintf(1,'%s: t(%d) = %.2f, p = %.3f\n',condstr,st.df(i),st.tstat(i),st.p(i))
end
disp('----')