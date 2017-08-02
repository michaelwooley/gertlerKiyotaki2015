%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find state vector 'z' s.t. x > 1 in SS.
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
    s0(t,:) = ssGt;%abs(randn(1,4));  % Initialize as abs(N(0,1))
    [sln(t,:),fval,ef] = fsolve( @(s) HssGt(s),s0(t,:),opt);
    
    snn = sln(t,:);
    % Test for constraints
    [test,~] = ssGtNlCon( sln(t,:) );
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
sss = mean(sln(ic,:));
Qmin =  ((sss(3)*sss(4))/(1-sss(2))) - Z;

fprintf('\nMin Q* for x > 1 SS: %4.3f\n',Qmin);
fprintf('SS Vector for case x > 1\n');
fprintf(['\tQss  = %8.6f\n\tkHss = %8.6f',...
    '\n\tDss  = %8.6f\n\tRss  = %8.6f\n'],sss);




