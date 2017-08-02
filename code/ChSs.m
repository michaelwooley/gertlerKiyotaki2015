function val = ChSs( s )
%ChSs - Ch given a state vector s = [Q,Kh,D,R]
% val = Z + Wh + Wb - (alpha/2)*(s(2))^2 - CbSs(s);

val = Z + Wh + Wb - (alpha/2)*(s(2))^2 - CbSs(s);

