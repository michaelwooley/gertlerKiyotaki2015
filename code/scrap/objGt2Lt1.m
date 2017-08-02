function [ s,flag,gtlt ] = objGt2Lt1( sp,Qrun,t,gtlt,re )
%objGt2Lt1 - Objective function. Case t > 2, x < 1
%   [ s,flag,gtlt ] = objGt2Lt1( sp,Qrun,t,options,re )

% Get root
cand = kRootsBack( sp,Qrun,t,gtlt );


% Find associated state vector
s = SvGt2Lt1(sp(3),Qrun,sp(1),cand,sp(2));
% Check to see if it is a valid solution
[~,c] = NlConGt2Lt1( s,sp(1),Qrun );


% If some constraint other than x < 1 not met
if any(c([5:6,8:end]) == 0)
    fprintf('\n\nWARNING: Not all constraints met: %i\n',t);
    fprintf('Individual Constraints\n');
    fprintf([repmat('%i ',1,length(c)),'\n'],1:length(c));
    fprintf([repmat('%i ',1,length(c)),'\n'],c);
    fprintf('Last s = \n');
    fprintf([repmat('%3.2f ',1,4),'\n'],s);
    fprintf('Terminating Loop\n');
    s = NaN;
    flag = -2;
    gtlt = NaN;
elseif c(7) == 0    % If x > 1
    
    % Do recursion. Check that haven't already done recursion.
    if re == 1
        fprintf('\n\tSwitching to case x > 1 at t = %i.\n',t-1);
        [ s,flag,~ ] = objGt2Gt1( sp,Qrun,t,1,re+1 );
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
    
elseif any(c(1:4) == 0)
%     fprintf('\nA non-state variable < 0 at iteration = %i\n',t); 
%     fprintf('Individual Constraints\n');
%     fprintf('N\tPhi\tCb\tCh\n');
%     fprintf([repmat('%i\t',1,4),'\n'],c(1:4));
%     fprintf('Stopping and computing t = 2\n');
    s = NaN;
    gtlt = 0;
    flag = 2;
   
else                % If all is well
    gtlt = 0;
    flag = 1; 
end

end

