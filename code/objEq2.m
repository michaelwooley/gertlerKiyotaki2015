function [ s2,flag,gtlt ] = objEq2( sp,Qrun,t,gtlt,re )
%objEq2 - Objective function. Case t = 2
%   [ s,flag,gtlt,s2 ] = objEq2( sp,Qrun,t,gtlt,re )

% Get root
cand = kRootsBack( sp,Qrun,t,gtlt );

% Check to see if it is a valid solution
if gtlt == 0
    s = SvEq2Lt1( sp,cand(1),Qrun );
    [~,c,s2 ] = NlConEq2Lt1( s,sp,Qrun );
else
    s = SvEq2Gt1( sp,cand(1),Qrun );
    [~,c,s2 ] = NlConEq2Gt1( s,sp,Qrun );    
end

% If some constraint other than 'x/P' not met
if c([1:11,13:end]) == 0
    fprintf('\n\nWARNING: Not all constraints met: %i\n',t);
    fprintf('Individual Constraints\n');
    fprintf([repmat('%i ',1,length(c)),'\n'],1:length(c));
    fprintf([repmat('%i ',1,length(c)),'\n'],c);
    fprintf('Terminating Loop\n');
    s = NaN;
    flag = -2;
elseif c(12) == 0    % If x > 1
    
    % Do recursion. Check that haven't already done recursion.
    if re == 1
        fprintf('\n\tSwitching to case x > 1 at t = %i.\n',t-1);
        [ s,flag,~ ] = objEq2( sp,Qrun,t,1-gtlt,re+1 );
        if flag == 1    % If switch case works, change flags.
            gtlt = 1-gtlt;
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

