%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Solve to one variable. Case t > 2, xtp1 > 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

%% 1. Define Variables
syms Qt kHt Dt Rt Pt cHt PhIt Nt ...
     Qtp1 kHtp1 Dtp1 Rtp1 Ptp1 cHtp1 PhItp1 Ntp1 ...
     Qrun 

%% 2. Aux. Eqns
xtp1 = (Z + Qrun)*(1-kHt)/((PhIt-1)*Nt*Rt);
Cbt  = ((1-sig)/sig)*(Nt-Wb);
Cbtp1  = ((1-sig)/sig)*(Ntp1-Wb);
t1 = (PhIt*((Z + Qtp1)/Qt) - Rt*(PhIt - 1));
t2 = Qt + alpha*kHt;
t3 = cHt/cHtp1;
t4 = cHt/Crun;

%% 3. Non-state equations
% For today
E3 = Pt   == 0;
E6 = cHt  == Z + Wh + Wb - (alpha/2)*(kHt^2) - Cbt;
E7 = PhIt == Qt*(1-kHt)/Nt;
E8 = Nt   == Qt*(1-kHt) - Dt;

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
[pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1] = solve(...
    [E3,E6,E7,E8,E6p1,E7p1,E8p1],...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1]);

% Substitute into H
Hs = subs(H,...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1],...
    [pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1]);

% Solve H
[Qk,Dk,Rk] = solve(Hs,[Qt,Dt,Rt]);

% Substitute all into Ks
Ks = subs(K,...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1],...
    [pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1]);

Kk = subs(Ks,[Qt,Dt,Rt],[Qk,Dk,Rk]);

% Separate out numerator and denominator
[Kkn,Kkd] = numden(Kk);
% Get Coefficients of Kkn
[Kknc,~] = coeffs(Kkn,kHt);
% Get Coefficients of Kkd
[Kkdc,tK] = coeffs(Kkd,kHt);

%% 6. Create Vector Function that maps to state vector
Fk(1) = Qk;
Fk(2) = kHt;
Fk(3) = Dk;
Fk(4) = Rk;
stateV(Dtp1, Qrun, Qtp1, kHt, kHtp1) = Fk;

%% 7. Create jacobian for state vector
sVj = subs(jacobian(Fk),kHt,kHtp1);

%% 8. Create Functions
vOut = {[Qtp1,kHtp1,Dtp1,Rtp1],Qrun};

% Map from next period values to HH Capital Polynomial Coefficients.
%   Numerator
matlabFunction(Kknc','File','KcGt2Gt1','Vars',vOut);
%   Denominator
matlabFunction(Kkdc','File','KdcGt2Gt1','Vars',vOut);

% Full Kk 
matlabFunction(Kk,'File','KkGt2Gt1','Optimize',false);

% State Vector
vOutS = {[Qtp1,kHtp1,Dtp1,Rtp1],kHt,Qrun};
matlabFunction(stateV,'File','SvGt2Gt1');

% State Vector Jacobian
matlabFunction(sVj,'File','SvJGt','Optimize',false,'Vars',vOut);

