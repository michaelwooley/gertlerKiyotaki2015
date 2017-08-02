%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ssEqnSet - Set up equations to find steady state of system.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
clc
syms Kh D Q R P Ch Phi N Qrun

%   Aux. Equations
x = ((Z+Qrun)*(1-Kh))/((Phi - 1)*N*R);
Cb = ((1-sig)/sig)*(N-Wb);

%   'z' SS Eqns
H(1) = - Phi + (bta/theta)*(1-P)*((1-sig) + sig*theta*Phi)*...
    (Phi*((Z+Q)/Q) - R*(Phi-1));
H(2) = -N + sig*N*(Phi*((Z+Q)/Q) - R*(Phi-1)) + Wb;
H(3) = -1 + bta*R*((1-P) + P*x*(Ch/Crun));
H(4) = -(Q + alpha*Kh) + bta*((1-P)*(Z+Q) + P*(Ch/Crun)*(Z+Qrun));

% Non-state Eqns.
SS6 = Ch  == Z + Wh + Wb - (alpha/2)*(Kh)^2 - Cb;
SS7 = Phi == (Q*(1-Kh))/N;
SS8 = N   == Q*(1-Kh) - D;

%% Case x < 1
%   Non-state Equation
SS3 = P == 1 - x;

% Solve for [P,Ch,Phi,N] in SS[4,6,7,8]
[pSs,ChSs,PhiSs,nSs] = solve([SS3,SS6,SS7,SS8],[P,Ch,Phi,N]);

% Substitute [P,Ch,Phi,N] into SS[1,2,4,5]
Hlt = subs(H,[P,Ch,Phi,N],[pSs,ChSs,PhiSs,nSs]);

% Create File, vectorize it, and check.
vOut = {[Q,Kh,D,R],Qrun};
matlabFunction(Hlt,'file','HssLt','Vars',vOut);

%% Case x > 1
%   Non-state Equation
SS3 = P == 0;

% Solve for [P,Ch,Phi,N] in SS[4,6,7,8]
[pSs,ChSs,PhiSs,nSs] = solve([SS3,SS6,SS7,SS8],[P,Ch,Phi,N]);

% Substitute [P,Ch,Phi,N] into SS[1,2,4,5]
Hgt = subs(H,[P,Ch,Phi,N],[pSs,ChSs,PhiSs,nSs]);

% Create File, vectorize it, and check.
vOut = {[Q,Kh,D,R]};
matlabFunction(Hgt,'file','HssGt','Vars',vOut);


