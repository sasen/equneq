function sigst = testSigmas(f,COND,ANLYZ)
%function sigst = testSigmas(f,COND,ANLYZ)
ecurs = f.ECUR(COND,:);
s6  = f.ss(ANLYZ,ecurs(1));
s12 = f.ss(ANLYZ,ecurs(2));
[~,p,ci,eqsigst] = ttest(s6,s12,[],'both');
eqsigst.p = p;
eqsigst.ci = ci;
sBeq = mean([s6 s12],2);

ucurs = f.UCUR(COND,:);
s3 = f.ss(ANLYZ,ucurs(1));
s4 = f.ss(ANLYZ,ucurs(2));
[~,p,ci,unsigst] = ttest(s3,s4,[],'both');
unsigst.p = p;
unsigst.ci = ci;
sBun = mean([s3 s4],2);

[~,p,ci,typest] = ttest(sBeq,sBun,[],'both');
typest.p = p;
typest.ci = ci;

sigst = catStruct(eqsigst,unsigst);
sigst = catStruct(sigst,typest);
