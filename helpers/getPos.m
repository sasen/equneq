n = 12;
xmax = 100; ymax = 200; xmin = -xmax; ymin=-ymax;

%xs = xmin + (xmax-xmin).*rand(n,1);
%ys = ymin + (ymax-ymin).*rand(n,1);

mu = [0 0]; %[1 2];
Sigma = 25*[1 .5; .5 2]; 
R = chol(Sigma);
R = [30 0; 0 60];
z = repmat(mu,n,1) + randn(n,2)*R;

ch = z(convhull(z),:);


figure(1); hold off
plot(z(:,1),z(:,2),'o','MarkerSize',10)
axis([xmin xmax ymin ymax]); axis square
hold on
plot(ch(:,1),ch(:,2),'r*','MarkerSize',10)
