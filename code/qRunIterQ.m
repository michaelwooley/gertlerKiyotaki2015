function [ spp,spInfo,flag ] = qRunIterQ( Qri,grad0m,gradAdj )
%qRunIterQ - Given a Qri find a) a starting point going to N2 b) the path
%   Differs from qRunIter in that it does a spline interpolation

% Init
maxN2 = 15;
N2 = 1;
flag2 = 0;

% SS
s0 = zeros(1,4);
w = 1;
V = 0;
Cons = 1;
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

% Find Jacobian at SS
ssj = SvJLt( ss,Qri );

while N2 < maxN2
      
    if N2 >= 2
        
        if flag2 == 0
            
            % Get the path
            [ sp,flag ] = backSolve( ss,grad0m,ssj,Qri );
            if flag ~= 1
                N2 = maxN2 + 100;
                flag = -1;
                return;
            end
            
            if size(sp,1) == spInfo(1,5) - 1
                
                spp{2} = sp;
                spInfo(2,:) = [sp(end,:),size(sp,1),grad0m,...
                                nSs(sp(1,:)),nSs(sp(2,:))];   
                N2 = N2 + 1;
                flag2 = 1;    
                
            elseif size(sp,1) == spInfo(1,5) + 1
               
                spp{2} = spp{1};
                spInfo(2,:) = spInfo(1,:);
                
                spp{1} = sp;
                spInfo(1,:) = [sp(end,:),size(sp,1),grad0m,...
                                nSs(sp(1,:)),nSs(sp(2,:))];   
                N2 = N2 + 1;                
                flag2 = 1;   
                
            elseif size(sp,1) == spInfo(1,5) 
                spp{1} = sp;
                spInfo(1,:) = [sp(end,:),size(sp,1),grad0m,...
                        nSs(sp(1,:)),nSs(sp(2,:))]; 
                N2 = N2 + 1; 
                grad0m = grad0m*1.05;               
            elseif size(sp,1) > spInfo(1,5) + 1
                spp{1} = sp;
                spInfo(1,:) = [sp(end,:),size(sp,1),grad0m,...
                        nSs(sp(1,:)),nSs(sp(2,:))]; 
                N2 = N2 + 1;
                grad0m = grad0m*0.75;
            elseif size(sp,1) < spInfo(1,5) - 1
                spp{1} = sp;
                spInfo(1,:) = [sp(end,:),size(sp,1),grad0m,...
                        nSs(sp(1,:)),nSs(sp(2,:))]; 
                N2 = N2 + 1; 
                grad0m = grad0m*gradAdj;
            end
            
        elseif flag2 == 1

            x(1) = spInfo(1,8);
            x(4) = spInfo(2,7);
            v(1) = spInfo(1,6);
            v(4) = spInfo(2,6);
            
            % Middle path 1
            grad0m = spInfo(1,6) + (1/3)*(spInfo(2,6) - spInfo(1,6));
            [ sp,~ ] = backSolve( ss,grad0m,ssj,Qri );  
            x(2) = nSs(sp(2,:))*(size(sp,1) == spInfo(1,5)) + ...
                    nSs(sp(1,:))*(size(sp,1) == spInfo(2,5));
            v(2) = grad0m;
            
            % Middle path 2
            grad0m = spInfo(1,6) + (2/3)*(spInfo(2,6) - spInfo(1,6));
            [ sp,~ ] = backSolve( ss,grad0m,ssj,Qri );  
            x(3) = nSs(sp(2,:))*(size(sp,1) == spInfo(1,5)) + ...
                    nSs(sp(1,:))*(size(sp,1) == spInfo(2,5));
            v(3) = grad0m;
                    
            % Interpolate
            grad0m = interp1(x,v,(1+sig)*Wb,'pchip');
            [ sp,~ ] = backSolve( ss,grad0m,ssj,Qri );
            if abs(nSs(sp(1,:))-(1+sig)*Wb) > abs(nSs(sp(2,:))-(1+sig)*Wb)
                sp = sp(2:end,:);
            end
            
            spp{3} = sp;
            spInfo(3,:) = [sp(end,:),size(sp,1),grad0m,...
                            nSs(sp(1,:)),nSs(sp(2,:))];   
            N2 = maxN2 + 100;
            flag = 1;           
            
        else
            fprintf('\nError: qRunIter : no more cases\n');
            flag = -2;
            return;
        end
        
    elseif N2 == 1
        
        % Get the path
        [ sp,flag ] = backSolve( ss,grad0m,ssj,Qri );
        if flag ~= 1
            N2 = maxN2 + 100;
            flag = -1;
            return;
        end
        
        spp{1} = sp;
        spInfo(1,:) = [sp(end,:),size(sp,1),grad0m,...
                        nSs(sp(1,:)),nSs(sp(2,:))];   
        N2 = N2 + 1;
        grad0m = grad0m*gradAdj;

    else
        fprintf('\nError: qRunIter : no more cases\n');
        flag = -3;
        return;
    end;

end

if N2 == maxN2
   fprintf('\nError: qRunIter: N2 == maxN2, Q* = %3.2f\n',Qri);
   flag = -4;
   return;
end

end

