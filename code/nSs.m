function val = nSs( s )
%nSs - N in SS given a state vector s = [Q,Kh,D,R]
%   val = s(1)*(1-s(2)) - s(3);


val = s(1)*(1-s(2)) - s(3);

