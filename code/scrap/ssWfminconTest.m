%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find state vector 's' s.t. x < 1 in SS.
%
% Conditions to be met:
% x > 1
% N > 0
% Phi > 0
% Cb > 0
% Ch > 0
% theta > Maximal Leverage/No-default > 0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

fprintf('Searching for SS with x > 1\n');

% Optimization Options
opt = optimset('display','off',...
    'MaxIter',4000,'MaxFunEvals',100000,'TolFun',1e-15);

% How many s0 to consider
T = 25;
% init storage
sln = -100*ones(T,4);
s0  = -100*ones(T,4);
cond = zeros(T,1);

for t=1:T
    s0(t,:) = abs(randn(1,4));  % Initialize as abs(N(0,1))
    [sln(t,:),fval,ef] = fsolve( @(s) Vgt(s),s0(t,:),opt);
    
    snn = sln(t,:);
    % Test for constraints
    test = (nSs(snn) > 0)*...
        (PhiSs(snn) > 0)*(CbSs(snn) > 0)*...
        (ChSs(snn) > 0)*(MLNdSs(snn) > 0)*...
        (MLNdSs(snn) < theta)*(snn > [0,0,0,0]);
    if test == 1
        cond(t) = 1;
        fprintf('Sln. Meeting All Conditions: %i\n',t);
        fprintf('sGt = \n');
        disp(snn);
        fprintf('s0 = \n');
        disp(s0(t,:));
        fprintf('Exit Flag = %i\n',ef);
        fprintf('Max(fval) = %4.3e\n\n',max(fval));
    end
end

fprintf('Done Searching for Solutions,\n\n');

% Test for (numeric) equality of proposed solutions.
lc = sum(cond);
ic = find(cond == 1);
for i=1:lc
    ii = ic(i);
    for j=i+1:lc
        jj = ic(j);
        msd(ii,jj) = max((sln(ii,:) - sln(jj,:)).^2);
    end
end
fprintf('Max Squared Difference Among Candidate Slns\n');
fprintf('\t = %3.2e\n',max(msd(:)));

% Find min Q* s.t. this is possible
sss = sln(ic(1),:);
xSolve = @(Q) xSs( sss,Q ) - 1;
[Qmin,xVal,flag] = fsolve(xSolve,1);