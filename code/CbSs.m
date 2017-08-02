function val = CbSs( s )
%CbSs - Cb given a state vector s = [Q,Kh,D,R]
% val = ((1-sig)/sig)*(nSs(s)-Wb);

val = ((1-sig)/sig)*(nSs(s)-Wb);

