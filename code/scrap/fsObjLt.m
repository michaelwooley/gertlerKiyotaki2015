function [ val,J ] = fsObjLt( z,H,dH,Qs,ss ) 
%fsObjLt - fsolve objective, case x < 1, optional Jacobian return

val = H(z,ss,Qs); 
   
% Optional return of gradient
if nargout > 1

   J = dH(z,ss,Qs);

end

end

