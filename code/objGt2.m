function [ s,flag,gtlt ] = objGt2( sp,Qrun,t,gtlt,nM,re )
%objGt2 - Objective function. Case t > 2
%   [ s,flag,gtlt ] = objGt2( sp,Qrun,t,gtlt,nM,re )
%
% FLAGS
%   1  - All is well                           => Go to t-1
%   2  - nSs is within neighborhood of N_2     => Go to t = 2
%   3  - Constraint not met                    => adjust grad0m
%   4  - No Roots                              => adjust adjGrad
%   0  - Successful Case Switch of x to >< 1   => Go to t-1
%   -1 - Unsuccesful Case Switch of x to >< 1  => Exit
%   -3 - Some other constraint not met         => adjust adjGrad

% Get root
cand = kRootsBack( sp,Qrun,t,gtlt );

if isnan(cand) == 1; 
    flag = 4; 
    s = NaN;
    fprintf('\nNo roots at t = %i\n',t);
    return;
end;

%    Find associated state vector
% &  Check to see if it is a valid solution
if gtlt == 0
    s = SvGt2Lt1( sp,cand(1),Qrun );
    [~,c] = NlConGt2Lt1( s,sp(1),Qrun );
else
    s = SvGt2Gt1(sp(3),Qrun,sp(1),cand,sp(2));
    [~,c] = NlConGt2Gt1( s,sp(1),Qrun );    
end

% If some constraint other than x < 1, nSs < 0 not met
if (abs(nSs(s) - (1+sig)*Wb) < (1+sig)*Wb*nM) 
    
    flag = 2;
    
elseif c(1) == 0
    
    flag = 3;
    
elseif any(c([2:6,8:end]) == 0)
    
    flag = -3;
    
elseif c(7) == 0    % If x > 1
    
    % Do recursion. Check that haven't already done recursion.
    if re == 1
%         fprintf('\n\tSwitching to case x > 1 at t = %i.\n',t-1);
        [ s,flag,~ ] = objGt2( sp,Qrun,t,1 - gtlt,nM,re+1 );
        if flag == 1    % If switch case works, change flags.
            gtlt = 1 - gtlt;
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
    
    flag = 1; 
    
end

end

