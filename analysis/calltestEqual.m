function [mEq, stat, condst] = calltestEqual(f,COND,ANLYZ)
  curs = f.ECUR(COND,:);
  m6  = f.ms(ANLYZ,curs(1));
  m12 = f.ms(ANLYZ,curs(2));
  [mEq, stat, condst] = testEqual(m6,m12);
  stat.conds = curs;
end