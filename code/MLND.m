function val = MLND( Q_t,Q_tp1,R_t )
%MLND - Maximal Leverage/No-default condition out of SS 
%   given a state vector s = [Q,Kh,D,R]
%   val = ((Z + s(1))/s(1)) - s(4); 

val = ((Z + Q_tp1)/Q_t) - R_t; 

