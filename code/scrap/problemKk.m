function [ f,J ] = problemKk(DTP1,QS,QTP1,KHT,KHTP1)
%problemKk - integrates Kk.m and dKk.m for fsolve

f = Kk(DTP1,QS,QTP1,KHT,KHTP1);

if nargout > 1
   
    J = dKk(DTP1,QS,QTP1,KHT,KHTP1);
    
end



end

