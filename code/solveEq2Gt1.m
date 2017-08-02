%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Backwards Solution. Case t = 2, xtp1 > 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

%% 1. Define Variables
syms Qt kHt Dt Rt Pt cHt PhIt Nt ...
     Qtp1 kHtp1 Dtp1 Rtp1 Ptp1 cHtp1 PhItp1 Ntp1 ...
     Qrun

%% 2. Aux. Eqns
xtp1 = (Z + Qrun)*(1-kHt)/((PhIt-1)*Nt*Rt);
Cbt  = (1-sig)*Wb;
Cbtp1  = ((1-sig)/sig)*(Ntp1-Wb);
t1 = (PhIt*((Z + Qtp1)/Qt) - Rt*(PhIt - 1));
t2 = Qt + alpha*kHt;
t3 = cHt/cHtp1;
t4 = cHt/Crun;

%% 3. Non-state equations
% For today
E3 = Pt   == 0;
E6 = cHt  == Z + Wh + (1+sig)*Wb - (alpha/2)*(kHt^2) - Cbt;
E7 = PhIt == Qt*(1-kHt)/Nt;
E8 = Nt   == (1+sig)*Wb;
D2 = Dt   == Qt*(1-kHt) - Nt;

% For tomorrow
E6p1 = cHtp1  == Z + Wh + Wb - (alpha/2)*(kHtp1^2) - Cbtp1;
E7p1 = PhItp1 == Qtp1*(1-kHtp1)/Ntp1;
E8p1 = Ntp1   == Qtp1*(1-kHtp1) - Dtp1;

%% 4. State Eqns.
% 4.1 To be solved.
H(1) = PhIt == (bta/theta)*(1-Pt)*(1-sig + sig*theta*PhItp1)*t1;
H(2) = Ntp1 == sig*Nt*t1 + Wb;
H(3) = 1 == Rt*bta*((1-Pt)*t3 + Pt*xtp1*t4);

% 4.2 To be substituted into.
K = -1 + bta*((1-Pt)*t3*((Z+Qtp1)/t2) + Pt*t4*((Z+Qrun)/t2));

%% 5. Manipulations
% Solve for E[3,6,7,8]
[pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1,dLt] = solve(...
    [E3,E6,E7,E8,E6p1,E7p1,E8p1,D2],...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1,Dt]);

% Substitute into H() - Leave out Eqn 3
Hs = subs(H(1:2),...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1,Dt],...
    [pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1,dLt]);

% Solve H
[Qk,Rk] = solve(Hs,[Qt,Rt]);
%   Must be taken care of specially:
Dk   = subs(dLt,[Qt,Rt],[Qk,Rk]);
Pk   = subs(pLt,[Qt,Rt],[Qk,Rk]);
PhIk = subs(PhiLt,[Qt,Rt],[Qk,Rk]);
cHk  = subs(ChLt,[Qt,Rt],[Qk,Rk]);
Nk   = subs(nLt,[Qt,Rt],[Qk,Rk]);

% Substitute all into Ks
Ks = subs(K,...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1,Dt],...
    [pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1,dLt]);

Kk = subs(Ks,[Qt,Rt],[Qk,Rk]);

%% 6. Create Vector Function that maps to state vector
Fk(1) = Qk;
Fk(2) = kHt;
Fk(3) = Dk;
Fk(4) = Rk;
stateV = Fk;

% Separate out numerator and denominator
[Kkn,Kkd] = numden(Kk);
% Get Coefficients of Kkn
[Kknc,tK] = coeffs(Kkn,kHt);
% Get Coefficients of Kkd
[Kkdc,tK] = coeffs(Kkd,kHt);

%% 7. Create Vector Function that maps to entire t = 2 Eqn. Solution
Fk(5) = Pk;
Fk(6) = Nk; 
Fk(7) = PhIk;
Fk(8) = cHk;
Fk(9) = (1-sig)*Wb; % Cb2
eqn = Fk;

%% 8. Generate Files
vOut = {[Qtp1,kHtp1,Dtp1,Rtp1],Qrun};

% Map from next period values to HH Capital Polynomial Coefficients.
%   Numerator
matlabFunction(Kknc','File','KcEq2Gt1','Vars',vOut);
%   Denominator
matlabFunction(Kkdc','File','KdcEq2Gt1','Vars',vOut);

% Full Kk 
matlabFunction(Kk,'File','KkEq2Gt1','Optimize',false);

% stateV
vOutS = {[Qtp1,kHtp1,Dtp1,Rtp1],kHt,Qrun};
matlabFunction(stateV,'file','SvEq2Gt1','Vars',vOutS);

% eqn
matlabFunction(eqn,'file','eqnEq2Gt1','Vars',vOutS);



