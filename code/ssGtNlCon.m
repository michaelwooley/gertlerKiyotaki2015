function [cc,c] = ssGtNlCon( s )
%ssGtNlCon - non-linear constraints for SS w/ x > 1
%   [cc,c] = ssGtNlCon( s )

%% NL Inequality Constraints c < 0
% N > 0
c(1) = (nSs(s) > 0);
% Phi > 0
c(2) = (PhiSs(s) > 0);
% Cb > 0
c(3) = (CbSs(s) > 0);
% Ch > 0
c(4) = (ChSs(s) > 0);
% Max Leverage
c(5) = (MLNdSs(s) > 0);
% No Default
c(6) = (MLNdSs(s) < theta);
% s > 0
c(7) = all(s >= 0);
% Kh =< 1
c(8) = (s(2) <= 1);

% Output as one big logical
cc = all(c);



end

