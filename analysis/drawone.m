function drawone(m, s, col)
curvecolors = 'bgrmbgrm';
p.x = linspace(-2,2);
p.g=0; p.l=0;
p.m = m; p.s = s;
pred = model(p);

%col = curvecolors(1);

%figure(), 
axis([-1 1 0 1]); hold on
plot(p.x, pred, [col '-'],'LineWidth',2)
plot(p.m,0.5, [col 'o'],'MarkerSize',15)
set(gca, 'FontSize', 24), grid on
%title('Ideal Psychometric Curve'); 
ylabel('Prop. Chose Left') 
%xlabel('log( mu1 / mu2 )')
text('')