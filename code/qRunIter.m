function [ spp,spInfo,flag ] = qRunIter( Qri,grad0m,gradAdj )%qRunIter( Qri,N2error,grad0m,gradAdj,re )
%qRunIter - Given a Qri find a) a starting point going to N2 b) the path

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
  
    % Get the path
    [ sp,flag ] = backSolve( ss,grad0m,ssj,Qri );
    if flag ~= 1
        N2 = maxN2 + 100;
        flag = -1;
        return;
    end
    
    if N2 >= 2
        
        if flag2 == 0
            
            if size(sp,1) == spInfo(1,5) - 1
                
                spp{2} = sp;
                spInfo(2,:) = [sp(end,:),size(sp,1),grad0m,...
                                nSs(sp(1,:)),nSs(sp(2,:))];   
                N2 = N2 + 1;
                
                [m,b] = linCoeff(spInfo(1:2,6),[spInfo(1,8),spInfo(2,7)]);
                grad0m = (((1+sig)*Wb - b)/m);
                
                flag2 = 1;    
                
            elseif size(sp,1) == spInfo(1,5) + 1
               
                spp{2} = spp{1};
                spInfo(2,:) = spInfo(1,:);
                
                spp{1} = sp;
                spInfo(1,:) = [sp(end,:),size(sp,1),grad0m,...
                                nSs(sp(1,:)),nSs(sp(2,:))];   
                N2 = N2 + 1;
                
                [m,b] = linCoeff(spInfo(1:2,6),[spInfo(1,8),spInfo(2,7)]);
                grad0m = ((1+sig)*Wb - b)/m;
                
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
            
            if abs(nSs(sp(1,:))-(1+sig)*Wb) > abs(nSs(sp(2,:))-(1+sig)*Wb)
                sp = sp(2:end,:);
            end
            
            spp{3} = sp;
            spInfo(3,:) = [sp(end,:),size(sp,1),grad0m,...
                            nSs(sp(1,:)),nSs(sp(2,:))];   
            N2 = maxN2 + 100;
            flag = 1;           
            if abs(log(nSs(sp(1,:))/((1+sig)*Wb))) > 50
                
                disp(abs(100*log(nSs(sp(1,:)/((1+sig)*Wb)))));
                disp('N2 Error BIG');
                disp(spInfo');
                
            end
            
        else
            fprintf('\nError: qRunIter : no more cases\n');
            flag = -2;
            return;
        end
        
    elseif N2 == 1
        
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

