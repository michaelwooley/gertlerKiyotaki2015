function val = MLNdSs( s )
%MLNdSs - Maximal Leverage/No-default condition in SS 
%   given a state vector s = [Q,Kh,D,R]
%   val = ((Z + s(1))/s(1)) - s(4); 

val = ((Z + s(1))/s(1)) - s(4); 

