function [ val,J ] = nllsObjLt( z,H,dH,Qs,ss ) %,t0,T )
%nllsObjLt

% % First, see if proposed 'z' is feasible
% %   Augment with D2 if t=2 part of z.
% if t0 == 2
%     zCheck = [z(1:2),z(1)*(1-z(2)) - (1+sig)*Wb,z(3:end)];
% else
%     zCheck = z;
% end
% zTest = -100*ones(1,T);
% idx = 1;
% if T ~= 1
%     for i=1:(T - 1)          
%         zTest(i) = pathLtNlCon(zCheck(idx:idx+3),zCheck(idx+4),Qs);
%         idx = idx + 4;
%     end
% end
% zTest(T) = pathLtNlCon(zCheck(idx:end),ss(1),Qs);

% If feasible, move forward. Otherwise, assign huge value
% if all(zTest(:) == 1)
   
    val = H(z,ss,Qs); 
   
   % Optional return of gradient
   if nargout > 1
      
       J = dH(z,ss,Qs);
   
   end
   
% else
%     
%     val = 1e100*ones(1,T);
%    
%    if nargout > 1
%       
%        J = 1e7*ones(4*T - 1*(t0 == 2));
%        
%    end
% end





end

