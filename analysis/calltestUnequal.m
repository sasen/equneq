function [mOS, plotst,condst] = calltestUnequal(f,COND,ANLYZ,mEq)
  curs = f.UCUR(COND,:);
  m3 = f.ms(ANLYZ,curs(1));
  m4 = f.ms(ANLYZ,curs(2));
  [mOS, plotst, condst] = testUnequal(m3,m4,mEq);
  plotst.conds = curs;
end