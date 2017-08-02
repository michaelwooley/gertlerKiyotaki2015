%% Steady State Map for x < 1
% Find steady state over a grid of Q*

clear all
close all
clc

% Define the grid
QgridLt = 0.99:-0.01:0.80;
Nq = length(QgridLt);

% Set up preferences, etc.
s0 = [0,0,0,0];
w = 1;
V = 0;
Cons = 1;

% Set up vectors
S = -1000*ones(Nq,4);
FH = -1000*ones(Nq,4);
Snu = cell([Nq,1]);
uniq = -1000*ones(Nq,1);

tb = tic;
fprintf('\tssLtMap\n');
fprintf('Q* \t\ttime \tStatus \tMax Resid. \tIter\n');
for i=1:Nq
    tbi = tic;
    [s,uniq(i),msg,fh] = ssFindLt( QgridLt(i),s0,w,V,Cons );
    if (uniq(i) == 0) && (all(isnan(s(:))) == 0)
       fv = -100*ones(size(s,1),1);
       for j=1:size(s,1)
          fv(j) = sum(Vlt( s(j,:),QgridLt(i)).^2); 
       end
       [~,imx] = min(abs(fv));
       S(i,:) = s(imx,:);
       Snu{i} = s;
       w = 1;
    elseif uniq(i) == 0 && isnan(s) == 1
        uniq(i) = NaN;
        w = 1;
    else
        S(i,:) = s;
        FH(i,:) = fh;
        s0 = s;
        w = 0.1;
    end
    fprintf('%4.3f\t%3.2f s.\t%s\t%3.2e\t%i/%i\n',...
        QgridLt(i),toc(tbi),msg,max(fh),i,Nq);
end

fprintf('\nMax residual for all Q* = %4.3e\n',max(FH(:)));
fprintf('Run Time: %3.2f sec.\n',toc(tb));

bds = 1:Nq;
% Plot out solutions
if length(QgridLt) < 150
    set(0,'DefaultLineMarkerSize',2);
else
    set(0,'DefaultLineMarkerSize',1e-10);
end
figure
subplot(2,2,1)
hold on
fvdl = min([S(bds,1)',QgridLt]):0.01:max([S(bds,1)',QgridLt]);
plot(QgridLt(bds),S(bds,1),'-o');
plot(fvdl,fvdl,':');
title('$Q_{ss}$');
axis('tight');
subplot(2,2,2)
plot(QgridLt(bds),S(bds,2),'-o');
title('$K^h_{ss}$');
subplot(2,2,3)
plot(QgridLt(bds),S(bds,3),'-o');
title('$D_{ss}$');
subplot(2,2,4)
plot(QgridLt(bds),S(bds,4),'-o');
title('$\bar{R}_{ss}$');














