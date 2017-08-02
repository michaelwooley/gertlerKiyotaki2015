function [ s,flag,gtlt ] = objEq2Lt1( sp,Qrun,t,options,re )
%objEq2Lt1 - Objective function. Case t = 2, x < 1
%   [ s,flag,gtlt ] = objEq2Lt1( sp,Qrun,t,options,re )

% Set up objective function
problem.objective = @(k) KkEq2Lt1(sp(3),Qrun,sp(1),k,sp(2));
% Initial guess - Last period's solution
problem.x0 = sp(2);
% Problem Solver
problem.solver = 'fsolve';
% Options
problem.options = options;

% Solve rootfinding problem
[cand,~,ef] = fsolve(problem);

if ef < 1
   fprintf('\n\nWARNING: Iteration = %i, Exit Flag = %i\n',t,ef);
   fprintf('Terminating Loop\n');
   flag = -3;
   return;
end

% Find associated state vector
s = SvEq2Lt1(sp(3),Qrun,sp(1),cand,sp(2));

% Check to see if it is a valid solution
[~,c] = NlConEq2Lt1(sp(3),Qrun,sp(1),cand,sp(2));

% If some constraint other than x < 1 not met
if c([1:4,6:10,12:end]) == 0
    fprintf('\n\nWARNING: Not all constraints met: %i\n',t);
    fprintf('Individual Constraints\n');
    fprintf([repmat('%i ',1,length(c)),'\n'],1:length(c));
    fprintf([repmat('%i ',1,length(c)),'\n'],c);
    fprintf('Terminating Loop\n');
    s = NaN;
    flag = -2;
elseif c(11) == 0    % If x > 1
    
    % Do recursion. Check that haven't already done recursion.
    if re == 1
        fprintf('\n\tSwitching to case x > 1 at t = %i.\n',t-1);
        [ s,flag,~ ] = objEq2Gt1( sp,Qrun,t,options,re+1 );
        if flag == 1    % If switch case works, change flags.
            gtlt = 1;
            flag = 0;
        end
        return; 
    else
        fprintf('\n\tERROR: Out of possible cases.\n');
        fprintf('Terminating Loop\n');
        s = NaN;
        flag = -1;
        return;
    end
    
else                % If all is well
    gtlt = 0;
    flag = 1; 
end

end

