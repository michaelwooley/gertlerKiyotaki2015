function [ sp,flag ] = backSolve( ss,grad0m,ssj,Qri )
%backSolve: Given a [SS,grad0m,ssj,Qri] solve the path backwards.

% Init 
Ts = 1000;
sp = -100*ones(Ts,4);   % solution path
sp(Ts,:) = ss + (ssj*ones(5,1)*grad0m)';
t = Ts - 1;
endLoop = 0;

if Qri < qGtMin
    gtlt = 0;
else
    gtlt = 1;
end

% Iterate solution
while (t > 2) && (endLoop == 0)
    
    % Get root
    cand = kRootsBack( sp(t+1,:),Qri,t,gtlt );

    if isnan(cand) == 1; 
        flag = 4; 
        s = NaN;
        fprintf('\nNo roots at t = %i\n',t);
        return;
    end;

    %    Find associated state vector
    % &  Check to see if it is a valid solution
    if gtlt == 0
        st = SvGt2Lt1( sp(t+1,:),cand(1),Qri );
        [c,cc] = NlConGt2Lt1( st,sp(t+1,:),Qri );
    else
        st = SvGt2Gt1( sp(t+1,:),cand(1),Qri );
        [c,cc] = NlConGt2Gt1( st,sp(t+1,:),Qri );    
    end
    
    if nSs(st) < (1+sig)*Wb
        sp(t,:) = st;
        sp = sp(t:end,:);
        t = -100;
        endLoop = 1;
        flag = 1;
    elseif c ~= 1
        fprintf('\nError: Constraint Violated. backSolve, line 47\n');
        fprintf('t = %i\n',Ts - t);
        fprintf('Q     Kh    D     R     Q*\n');
        fprintf('%4.3f %4.3f %4.3f %4.3f %4.3f\n',st,Qri);
        fprintf('Constraints:\n');
        fprintf([repmat('%i ',1,length(cc)),'\n'],1:length(cc));
        fprintf([repmat('%i ',1,length(cc)),'\n'],cc);
        t = -100;
        endLoop = 1;
        flag = -1;
        return;
    elseif c == 1
        sp(t,:) = st;
        t = t - 1;
    else
        fprintf('\nError: Unknown. backSolve, line 56\n');
        t = -100;
        endLoop = 1;
        flag = -2;
        return;        
    end

end

end

