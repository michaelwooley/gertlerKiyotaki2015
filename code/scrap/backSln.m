function [ sp,Qrm,spInt ] = backSln( ...
    Qrun0,Tol,maxIter,nM,maxN2,grad0m,gradAdj )
%backSln - Backwards-solving solution.

% Init status variables
ttotal = tic;
endLoop = 0;
iter = 1;
Qri = Qrun0;    % Q* guess in current iteration
dSign = -100;
spInt = [];

% Init Adjustments/Tolerances for N_2
if isempty(maxN2); maxN2 = 100; end
N2 = 1; 
if isempty(gradAdj); gradAdj = 1.1; end    
if isempty(nM); nM = 1/4; end

% SS Variables
s0 = zeros(1,4);
w = 0.5;
V = 0;
Cons = 1;

% Backwards solution parameters
Ts = 1000;   %   Max possible backwards iterations

% Init storage
%   Past Q* guesses.
Qrm = -1000*ones(maxIter,1);

fprintf('\t\tbackSln\n');
fprintf('Max Loops = %i\tTolerance = %3.2e\n\n',maxIter,Tol);
fprintf('Loop \tQ* \t\tDiff \tFlag \tTime\n');

while (endLoop == 0) && (iter <= maxIter)
    
    fprintf('%i \t %10.8f',iter,Qri);
    % Determine which side of SS divide Qri is on
    if Qri > qGtMin
        gtlt = 1;
    else
        gtlt = 0;
    end
    
    % Find SS
    [ ss,uniq,msg ] = ssRoute( Qri,s0,w,V,Cons );
    if uniq ~= 1 
        fprintf('\nSS for Q* = %4.3f N0 Good\.n',Qri);
        fprintf('uniq = %i\tmsg: %s\n',uniq,msg);
        endLoop = 1;
    elseif isnan(ss) == 1
        endLoop = 1;
        iter = 1e100;
        return;
    end
    
    % Find jacobian at SS
    flag = -100;
    ssj = SvJLt( ss,Qri )*ones(5,1);
    
    while (flag ~= 2) && (N2 < maxN2) 
       
        % Backwards solve
        sp = -100*ones(Ts,4);   % solution path
        sp(Ts,:) = ss + (ssj*grad0m)';
        t = Ts - 1;
        
        % Solve backwards recursively
        %   This for loop solves up to t = 3
        while (t > 2) && (endLoop == 0)

            % Look for state vector
            [st,flag,gtlt] = objGt2( sp(t+1,:),Qri,t,gtlt,nM,1 );
        
            % Check output
            if (flag == 1 || flag == 0)         % All looks good        
                sp(t,:) = st;
                t = t - 1;
            elseif N2 >= 2 && (flag == 3 || flag == -3)    % Adjust grad0m
                disp([nSs(sp(t+1,:)) - (1+sig)*Wb,(1+sig)*Wb*nM]);
                gIp(N2,4) = t;
                gIp(N2,3) = nSs(sp(t+1,:));
                gIp(N2,2) = nSs(st);
                gIp(N2,1) = grad0m;
                spInt(N2,:) = [sp(end,:),gIp(N2,:)];   % ^^~~^^ %
                if t == gIp(N2-1,4) + 1
                    [~,m(1),b(1)] = linCoeff( spInt(2:-1:1,5),[spInt(2,7),spInt(1,6)] );
                    [~,m(2),b(2)] = linCoeff( spInt(2:-1:1,5),[spInt(2,6),spInt(1,7)] );
%                     grad0m = ((1+sig)*Wb - b(1))./m(1);
                    grad0m = mean(((1+sig)*Wb - b)./m);
%                     grad0m = (b(1) - b(2))/(m(2) - m(1));
                else
                    fprintf('\nNo dice\n');
                end
                N2 = N2 + 1;
                t2 = t;
                t = -100;
            elseif (flag == 3 || flag == -3)    % Adjust grad0m
                gIp(N2,4) = t;
                gIp(N2,3) = nSs(sp(t+1,:));
                gIp(N2,2) = nSs(st);
                gIp(N2,1) = grad0m;
                spInt(N2,:) = [sp(end,:),gIp(N2,:)];   % ^^~~^^ %
                grad0m = grad0m*gradAdj;
                N2 = N2 + 1;
                t2 = t;
                t = -100;
            elseif flag == 4
                gradAdj = 0.5*(1+gradAdj);
                grad0m = grad0m*gradAdj;
                N2 = N2 + 1;
                t2 = t;
                t = -100;
            elseif flag == 2                    % Within range of N_2
                sp = sp([1:2,t+1:end],:);
                if isempty(spInt) == 0
                gIp(N2,4) = t;
                gIp(N2,3) = nSs(sp(t+1,:));
                gIp(N2,2) = nSs(st);
                gIp(N2,1) = grad0m;
                spInt(N2,:) = [sp(t+1,1),sp(end,2:4),gIp(N2,:)];   % ^^~~^^ %
                end
                fprintf(' %i %i ',Ts-t,N2);
                t = 2;
            else
                grad0m = grad0m;
                N2 = maxN2 + 100;
                t = -100;
                endLoop = 1;
                fprintf('\nError: backSln, line 85\n');
                return;
            end

        end
        
    end
    
    if N2 == maxN2
        fprintf('\nMax N2 Reached, flag = %i\n',flag);
        fprintf('grad0m = %3.2e, nM = %3.2e\n',grad0m,nM);
        fprintf('Last Q* = %12.10f\n',Qri);
        fprintf('Returning...\n');
        sp(t2,:) = st;
        sp = sp(t2:end,:);
        Qrm = Qrm(t2:end);
        endLoop = 1;
        iter = maxIter + 100;
        return;
    end
        
    %% Solve for root at t = 2
    % Get root
    [ s2,flag2,~ ] = objEq2( sp(t+1,:),Qri,t,gtlt,1 );

    if flag2 < 0                 % Non-successful run
        endLoop = 1;
        iter = maxIter + 100;
        sp(2,:) = s2(1:4);  % For debugging purposes
        return;
    else                        % Success
        sp(2,:) = s2(1:4);
    end

    % Condition - cHk = s2(8), Q = s2(1)
    QrunP = bta*(Crun/s2(8))*(s2(1) + Z) - alpha;
    diffr = abs((QrunP - Qri)/Qri);
    if diffr == ((QrunP - Qri)/Qri)
        fprintf('\t+%3.2e\t%i\t\t%3.2fs.\n',diffr,flag,toc(ttotal));
        if (iter ~= 1) && (dSign == 0)
           dSign = 1;
           nM = nM / 2;
           gradAdj = (gradAdj + 1)/2;
        elseif iter == 1
           dSign = 1;
        end
    else
        fprintf('\t-%3.2e\t%i\t\t%3.2fs.\n',diffr,flag,toc(ttotal));
        if (iter ~= 1) && (dSign == 1)
           dSign = 0;
           nM = nM / 2;
           gradAdj = (gradAdj + 1)/2;
        elseif iter == 1
           dSign = 0;
        end        
    end
    if abs(diffr) < Tol 
        fprintf('\n\tSolution found: Q* = %12.10f\n',mean([Qri,QrunP]));
        Qrm(iter) = mean([Qri,QrunP]);
        Qrm = Qrm(1:iter);
        iter = maxIter + 100;
        endLoop = 1;
    end

    % Save all
    s0 = ss;    % Steady state
    Qrm(iter) = Qri;
    Qri = QrunP;
    gtlt = (Qri >= qGtMin);
    iter = iter + 1;
    N2 = 1;
        
end

fprintf('\n\tTotal Time = %3.2f s.\n',toc(ttotal));

end

