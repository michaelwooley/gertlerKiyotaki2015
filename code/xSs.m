function val = xSs( s,Qs )
%xSs - x given a state vector s = [Q,Kh,D,R]
%   val = ((Z+Qs)*(1-s(2)))/(s(3)*s(4));

val = ((Z+Qs)*(1-s(2)))/(s(3)*s(4));



