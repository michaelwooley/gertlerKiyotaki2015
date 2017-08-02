%% kRootsBack Test Script

clear all
close all
clc

% Use some old results
load('backSlnTestMat.mat');

% Narrow focus
Qrm = Qrm{3};
Qrun = Qrun0(3);
sp = sp{3};

% Ex. 1 - More than one root!
gtlt = 0;
t = 50;
stp1 = sp(t+1,:);

root = kRootsBack( stp1,Qrun,t,gtlt );

% Check if comes out in KkGt2Lt1 - it doesn't!
x0 = 0.99;
r(1) = fsolve(@(k) KkGt2Lt1(stp1(3),Qrun,stp1(1),k,stp1(2)),x0);
x0 = 0.5;
r(2) = fsolve(@(k) KkGt2Lt1(stp1(3),Qrun,stp1(1),k,stp1(2)),x0);
disp(r);

% RESOLUTION: Also a root in the denominator at that point.

% graph it
% Full
KkF = @(k) KkGt2Lt1(stp1(3),Qrun,stp1(1),k,stp1(2));
% No Denom
cN = KcGt2Lt1( stp1,Qrun);
cD = KdcGt2Lt1( stp1,Qrun);
KkN = @(k) [k.^4,k.^3,k.^2,k,1]*cN;
KkD = @(k) [k.^4,k.^3,k.^2,k,1]*cD;
KkB = @(k) ([k.^4,k.^3,k.^2,k,1]*cN) ./ ([k.^4,k.^3,k.^2,k,1]*cD);

grid = 1e-10:1e-3:1;
KkFv = -100*ones(1,length(grid));
KkBv = -100*ones(1,length(grid));
KkDv = -100*ones(1,length(grid));
for i=1:length(grid)
    KkFv(i) = KkF(grid(i));
    KkBv(i) = KkB(grid(i));
    KkDv(i) = KkD(grid(i));
end

grid2 = 1e-10:1e-5:1;
KkNv = -100*ones(1,length(grid2));
for i=1:length(grid2)
    KkNv(i) = KkN(grid2(i));
end

figure
hold on
set(0,'defaultTextInterpreter','latex');
[hAx,hLine1,hLine2] = plotyy(grid,KkFv,grid2,KkNv);
hLine1.LineWidth = 1.5;
hLine2.LineWidth = 1.5;
hAx(2).YLim = [-1e90,1e90];
hAx(1).YLabel.String = 'Entire $H$';
hAx(1).YLabel.Color = 'k';
hAx(2).YLabel.String  = 'Numerator/Denominator of $H$';
hAx(2).YLabel.Color = 'k';
hAx(1).XLabel.String = 'k';
hAx(1).XLabel.Color = 'k';
hold on
line(grid,KkDv,'parent',hAx(2),'color',[0.4940    0.1840    0.5560],...
    'lineWidth',1.5);
line(grid,KkBv,'parent',hAx(1),'color',[0.9290    0.6940    0.1250],...
    'lineWidth',1.5,'LineStyle','--');
hline(0,'k--')
legend('H','H - Num/Denom','Numerator','Denominator');
% cleanfigure();
% cleanfigure('minimumPointsDistance',1e-4);
% matlab2tikz('paperObjects/hRootsDemo.tex');

% Ex. 2
gtlt = 1;
t = 50;
stp1 = sp(t+1,:);

root = kRootsBack( stp1,Qrun,t,gtlt );

% Ex. 3
gtlt = 1;
t = 2;
stp1 = sp(t+1,:);

root = kRootsBack( stp1,Qrun,t,gtlt );

% Ex. 3
gtlt = 0;
t = 2;
stp1 = sp(t+1,:);

root = kRootsBack( stp1,Qrun,t,gtlt );
