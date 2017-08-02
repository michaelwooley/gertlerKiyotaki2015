%% Solution Iteration Prototype

clear all
clc

fprintf('\tSolution Iteration Prototype\n');
ttotal = tic;
Ts = 400;
Tol = 1e-8;
endLoop = 0;

% Set Q*
Qri = 0.9;
fprintf('\t\tQ* = %4.3f\n',Qri);

% Determine which side of SS divide Qri is on
if Qri > qGtMin
    gtlt = 1;
else
    gtlt = 0;
end

% Find SS
s0 = zeros(1,4);
w = 1;
V = 0;
Cons = 1;

[ ss,uniq,msg ] = ssRoute( Qri,s0,w,V,Cons );
if any([(uniq ~= 1),(isnan(ss) == 1)])
    fprintf('\nSS for Q* = %4.3f NO Good\.n',Qri);
    fprintf('uniq = %i\tmsg: %s\n',uniq,msg);
    endLoop = 1;
    return;
end

% Backwards solve
goto2   = 0;
sp = -100*ones(Ts,4);   % solution path
sp(Ts,:) = ss;
t = Ts - 1;
% Solve backwards recursively
%   This for loop solves up to t = 3
while (t > 2) && ((endLoop == 0) && (goto2 == 0))

    % Find state vector
    [st,flag,gtlt] = objGt2( sp(t+1,:),Qri,t,gtlt,1 );

    % Check output
    if flag == 1 || flag == 0
        sp(t,:) = st;
        t = t - 1;
    elseif flag == 2
        sp = sp([1:2,t+1:end],:);
        fprintf(' %i',t);
        t = 2;
        goto2 = 1;
    elseif flag == 3
        sp = sp([1:2,t+1:end],:);
        fprintf(' %i',t);
        t = 2;
        goto2 = 1;
    else
        endLoop = 1;
        return;
    end

end

if endLoop == 1; return; end

%% Solve for root at t = 3
[ st,flag2,gtlt ] = objEq2( sp(t+1,:),Qri,t,gtlt,1 );

% Check output
if flag2 == 1 || flag2 == 0
    sp(t,:) = st;
else
    endLoop = 1;
    return;
end 

if endLoop == 1; return; end

% Check Q* Fixed point condition
if gtlt == 0    % if x < 1
    s2 =  eqnEq2Lt1(sp(t+1,3),Qri,sp(t+1,1),sp(t,2),sp(t+1,2));
else            % if x >= 1
    s2 =  eqnEq2Gt1(sp(t+1,3),Qri,sp(t+1,1),sp(t,2),sp(t+1,2));
end

% Condition
QrunP = bta*(Crun/s2(8))*(s2(1) + Z) - alpha;
diff = abs((QrunP - Qri)/Qri);
if diff == ((QrunP - Qri)/Qri)
    fprintf('\t+%3.2e\t%i\t\t%3.2fs.\n',diff,flag,toc(ttotal));
else
    fprintf('\t-%3.2e\t%i\t\t%3.2fs.\n',diff,flag,toc(ttotal));
end
if abs(diff) < Tol 
    fprintf('\n\tSolution found: Q* = %12.10f\n',mean([Qri,QrunP]));
    Qrm(iter) = mean([Qri,QrunP]);
    Qrm = Qrm(1:iter);
    iter = 1e100;
else
    fprintf('\n\t Q*'' = %12.10f\n',QrunP);
end


