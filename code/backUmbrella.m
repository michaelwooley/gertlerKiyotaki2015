function [ sp,Qrm ] = backUmbrella( Q0,Tol,maxIter,grad0m,gradAdj,M,V )
%backUmbrella - Umbrella function for the backwards iteration procedure.

% Init status variables
ttotal = tic;
endLoop = 0;
iter = 1;
Qri = Q0;    
gtlt = 0; % hardwiring this - fairly certain this case isn't relevant.

fpfv(V,'\t\t << backUmbrella >>\n');
fpfv(V,'Max Loops = %i\tTolerance = %3.2e\n\n',maxIter,Tol);
fpfv(V,'Loop \tQ*\t\tdQ*/dLoop\tN2 Error \tTime\n');
while (endLoop == 0) && (iter <= maxIter)
    
    fpfv(V,'%i \t %10.8f',iter,Qri);
    
    % Solve Path backwards to N_2 = (1+sig)*Wb
    %   Will yield t = 2,...,M. But only 3...M used in final.
    [ spp,~,flag ] = qRunIterRoute( M,Qri,grad0m,gradAdj );
    if flag < 0                 % Non-successful run
        endLoop = 1;
        iter = maxIter + 100;
        sp(2,:) = s2(1:4);          
        return;
    else                         % Success
        sp = spp{3};
        N2diff = 100*log(nSs(sp(1,:))/((1+sig)*Wb));
    end        
    
    % Solve at t = 2
    [ s2,flag2,~ ] = objEq2( sp(2,:),Qri,2,gtlt,1 ); 
    if flag2 < 0                 % Non-successful run
        endLoop = 1;
        iter = maxIter + 100;
        sp(1,:) = s2(1:4);          
        return;
    else                         % Success
        sp(1,:) = s2(1:4);
    end
    
    % Condition - cHk = s2(8), Q = s2(1)
    QrunP = bta*(Crun/s2(8))*(s2(1) + Z) - alpha;
    diffr = abs((QrunP - Qri)/Qri);
    if diffr == ((QrunP - Qri)/Qri)
        fpfv(V,'\t+%3.2e',diffr);
    else
        fpfv(V,'\t-%3.2e',diffr);  
    end
    if N2diff > 0
        fpfv(V,'\t+%3.2f%%  \t%3.2fs.\n',N2diff,toc(ttotal));
    else
        fpfv(V,'\t%3.2f%%  \t%3.2fs.\n',N2diff,toc(ttotal));
    end
    
    % Check for convergence
    if abs(diffr) < Tol 
        fpfv(V,'\n\tSolution found: Q* = %12.10f\n',mean([Qri,QrunP]));
        Qrm(iter) = mean([Qri,QrunP]);
        Qrm = Qrm(1:iter);
        Rrun = (1/bta)*(s2(8)/Crun);
        sp = [Qrm(end),1,0,Rrun;sp];
        iter = maxIter + 100;
        endLoop = 1;
        fpfv(V,'\n\tTotal Time = %3.2f s.\n',toc(ttotal));
        return;
    end 
    
    % Save
    Qrm(iter) = Qri;
    Qri = QrunP;
    iter = iter + 1;    
    
end
    
end

