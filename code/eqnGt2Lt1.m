function eq = eqnGt2Lt1( s,Qrun )
%eqnGt2Lt1 - Returns vector of equilibria values given state (s,Qrun)

% State Vectors
eq(1:4) = s;
% P
eq(5) = 1 - xSs(s,Qrun);
% N
eq(6) = nSs(s);
% Phi
eq(7) = PhiSs(s);
% Ch
eq(8) = ChSs(s);
% Cb
eq(9) = CbSs(s);

end

