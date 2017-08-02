%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find state vector 'z' s.t. x < 1 in SS.
%
% Conditions to be met:
% x < 1
% N > 0
% Phi > 0
% Cb > 0
% Ch > 0
% theta > Maximal Leverage/No-default > 0
% s  > 0   
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

% How many s0 to consider
T = 25;
% Q*
Qrun = 0.9;

fprintf('Searching for SS with x < 1 and Q* = %3.2f\n',Qrun);

% Objective
HHlt = @(s) HssLt( s,Qrun );

% Optimization Options
opt = optimset('display','off');


% init storage
sln = -100*ones(T,4);
s0  = -100*ones(T,4);
cond = zeros(T,1);

for t=1:T
    
    s0(t,:) = ssLtInitDraw( Qrun ); % Draw initial guess
    [sln(t,:),fval,ef] = fsolve( HHlt,s0(t,:),opt);
       
    snn = sln(t,:);
    % Don't count bad exits
    if ef < 1; continue;end
    % Test for constraints
    test = ssLtNlCon( snn,Qrun );
    if test == 1
        cond(t) = 1;
        fprintf('Sln. Meeting All Conditions: %i\n',t);
        fprintf('\tExit Flag = %i\tMax(fval) = %4.3f\n',ef,max(fval));
    end
end

fprintf('Done Searching for Solutions,\n\n');

% Test for (numeric) equality of proposed solutions.
lc = sum(cond);
ic = find(cond == 1);
if sum(cond) > 0
    msd = zeros(lc);
    for i=1:lc
        ii = ic(i);
        for j=i+1:lc
            jj = ic(j);
            msd(ii,jj) = ...
                max((sln(ii,:) - sln(jj,:)).^2);
        end
    end
fprintf('Max Squared Difference Among Candidate Slns\n');
fprintf('\t = %3.2e\n',max(msd(:)));
end

% Check that 'solution' actually solves state eqns.
ss = sln(ic(1),:);
fprintf('Max residual of state eqns. = %3.2e\n',max(Hlt(ss,ss,Qrun)));







