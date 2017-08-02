%% final - Econ 416
%   Michael Wooley
%   15 December  2015

%% Parameter Values => own functions
% alpha = 0.00797;
% theta = 0.1934;
% sig   = 0.95;
% bta   = 0.99;
% Wh    = 0.045;
% Wb    = 0.001148/10;
% Z     = 0.0126;

fprintf('Parameter Values:\n');
fprintf('alpha = %4.3f\n',alpha);
fprintf('theta = %4.3f\n',theta);
fprintf('sigma = %4.3f\n',sig);
fprintf('beta  = %4.3f\n',bta);
fprintf('Wh    = %4.3f\n',Wh);
fprintf('Wb    = %4.3e\n',Wb);
fprintf('Z     = %4.3f\n',Z);

% % Scripts that form all of the underlying functions
% ssEqnSet;
% solveEq2Gt1;
% solveEq2Lt1;
% solveGt2Gt1;
% solveGt2Lt1;

% % The SS for case x > 1
% xGt1SS;

% Find the equilibrium path
fprintf('\nFinding the equilibrium path...\n\n');
M = 2;      % Says to use pchip interpolation method, M = 1 is linear
Tol = 1e-8;     % Convergence level for Q*
maxIter = 100;  % Maximum number of iterations to complete
grad0m = 1e-8;  % For use in qRunIterQ - see text
gradAdj = 1.05; % ditto ^
V = 1;          % Verbose output
Q0 = 0.98;      % Initial Q* to try - invariant to this choice.
[ sp,Qrm ] = backUmbrella( Q0,Tol,maxIter,grad0m,gradAdj,M,V );

% Produce Q* mapping 
fprintf('\nqRunMapping - Now Producing Q* figure...\n');
qRunMapping

% Create Equilibrium Maps
fprintf('\neqnPathFigure - Producing equilibrium paths...\n');
eqnPathFigure

% Create table of equilibrium values
fprintf('\nNow Creating Table of Path Values\n');
periods = [2,60,120,160];
lp = length(periods);

% Data
for i=1:lp
    dta(:,i) = eqnGt2Lt1(sp(periods(i),:),Qrm(end));
end
dta(:,i+1) = ss;

% Labels
ColLabels = {'2','60','120','160','Steady State'};
RowLabels = {'$Q_t$','$K^h_t$','$D_t$','$\bar{R}_t$',...
       '$P_t$','$N_t$','$\Phi_t$','$C^h_t$','$C^b_t$'};

fprintf('\n\t\t');
for i=1:lp+1
   fprintf('%s\t\t',ColLabels{i});
end
fprintf('\n');
for i=1:9
   fprintf(['%s\t',repmat('%5.4f\t',1,lp+1),'\n'],RowLabels{i},dta(i,:));
end

% Simulation
fprintf('\nsimuPath - Simulating the economy...\n');
manySims








