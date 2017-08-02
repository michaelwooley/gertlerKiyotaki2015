function [ cc,c,s ] = NlConEq2Gt1( s,sp,QRUN )
%NlConEq2Gt1 - Non-linear Constraints at t = 2 w/ x >= 1
%   [ cc,c,s ] = NlConEq2Gt1( s,sp,QRUN )

% Find solution
s = eqnEq2Gt1( sp,s(2),QRUN );

% Check that it is > 0
c(1:9) = (s > 0);

% Max Leverage
mlndi = MLND(s(1),sp(1),s(4));
c(10) = (mlndi > 0);
% No Default
c(11) = (mlndi < theta);
% x >= 1
c(12) = (((Z+QRUN)*(1-s(2))) >= (s(3)*s(4)));
% Kh =< 1
c(13) = (s(2) <= 1);
% Q > Q*        (or else not a firesale)
c(14) = (s(1) > QRUN);

% Output as one big logical
cc = all(c);

end

