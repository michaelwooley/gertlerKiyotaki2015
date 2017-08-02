function val = PhiSs( s )
%PhiSs - Phi given a state vector s = [Q,Kh,D,R]
% val = (s(1)*(1-s(2)))/nSs(s);

val = (s(1)*(1-s(2)))/nSs(s);

