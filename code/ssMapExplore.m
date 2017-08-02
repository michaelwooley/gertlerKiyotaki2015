%% Steady State Map for x in R+
% Find steady state over a grid of Q*

clear all
close all
clc

% Define the grid
Qgrid = 0.80:0.01:1.15;
Nq = length(Qgrid);

% Set up preferences, etc.
s0 = [0,0,0,0];
w = 1;
V = 0;
Cons = [];

% Set up vectors
S = -1000*ones(Nq,4);
FH = -1000*ones(Nq,4);
Cond = -1000*ones(Nq,1);
Snu = cell([Nq,1]);
uniq = -1000*ones(Nq,1);

tb = tic;
fprintf('\tssLtMap - %i Q* to Check\n',Nq);
fprintf('Q* \t Status \tMax Resid. \tCondition\tIter\n');
for i=1:Nq
    tbi = tic;
    
    if Qgrid(i) < 0.9965
        Cons = 1;
    else
        Cons = 0;
    end
    
    [s,uniq(i),msg,fh,cond] = ssFindLt( Qgrid(i),s0,w,V,Cons );
    if (uniq(i) == 0) && (all(isnan(s(:))) == 0)
       fv = -100*ones(size(s,1),1);
       for j=1:size(s,1)
          fv(j) = sum(Hlt( s(j,:),s(j,:),Qgrid(i)).^2); 
       end
       [~,imx] = min(abs(fv));
       S(i,:) = s(imx,:);
       Snu{i} = s;
       w = 1;
       stat = -1;
    elseif uniq(i) == 0 && isnan(s) == 1
        uniq(i) = NaN;
        FH(i,:) = -100*ones(1,4);
        Cond(i) = -2;
        w = 1;
        stat = -2;
    else
        S(i,:) = s;
        FH(i,:) = fh;
        Cond(i) = max(cond);
        s0 = s;
        w = 0.1;
        stat = 1;
    end
    fprintf('%4.3f \t%i \t%3.2e \t\t%i  \t\t %i\n',...
        Qgrid(i),stat,max(abs(FH(i,:))),Cond(i),i);
end

fprintf('\nMax residual for all Q* = %4.3e\n',max(FH(:)));
fprintf('Run Time: %3.2f sec.\n',toc(tb));


% Plot out solutions
bds = 1:Nq;
bds1 = 1:length(Cond(Cond == 1));
bds2 = (max(bds1)+1):Nq;
ssgt = ones(length(bds2),1)*ssGt;
fvdl = min([S(bds1,1)',Qgrid]):0.01:max([S(bds,1)',Qgrid]);
refGt = ones(length(fvdl),1)*qGtMin;
ms = 1;

figure('Name','SS Mapping');
subplot(2,2,1)
hold on
plot(Qgrid(bds),[S(bds1,1);ssgt(:,1)],'-o','MarkerSize',ms);
plot(fvdl,fvdl,':');
title('$Q_{ss}$');
xlim([Qgrid(1),Qgrid(end)]);
ylim([Qgrid(1),Qgrid(end)]);
subplot(2,2,2)
plot(Qgrid(bds),[S(bds1,2);ssgt(:,2)],'-o','MarkerSize',ms);
title('$K^h_{ss}$');
xlim([Qgrid(1),Qgrid(end)]);
subplot(2,2,3)
plot(Qgrid(bds),[S(bds1,3);ssgt(:,3)],'-o','MarkerSize',ms);
title('$D_{ss}$');
xlim([Qgrid(1),Qgrid(end)]);
subplot(2,2,4)
plot(Qgrid(bds),[S(bds1,4);ssgt(:,4)],'-o','MarkerSize',ms);
title('$\bar{R}_{ss}$');
xlim([Qgrid(1),Qgrid(end)]);

% cleanfigure();
% matlab2tikz('paperObjects/SSmapping.tex');




