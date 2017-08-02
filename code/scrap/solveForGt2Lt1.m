%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Backwards Solution. Case t > 2, xtp1 < 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

%% 1. Define Variables
syms Qt kHt Dt Rt Pt cHt PhIt Nt ...
     Qtp1 kHtp1 Dtp1 Rtp1 Ptp1 cHtp1 PhItp1 Ntp1 ...
     Qrun 

%% 2. Aux. Eqns
xtp1 = (Z + Qrun)*(1-kHt)/((PhIt-1)*Nt*Rt);
xtp2 = (Z + Qrun)*(1-kHtp1)/((PhItp1-1)*Ntp1*Rtp1);
Cbt  = ((1-sig)/sig)*(Nt-Wb);
Cbtp1  = ((1-sig)/sig)*(Ntp1-Wb);
t1 = (PhIt*((Z + Qtp1)/Qt) - Rt*(PhIt - 1));
t2 = Qt + alpha*kHt;
t3 = cHt/cHtp1;
t4 = cHt/Crun;

%% 3. Non-state equations
% For today
E3 = Pt   == 1 - xtp1;
E6 = cHt  == Z + Wh + Wb - (alpha/2)*(kHt^2) - Cbt;
E7 = PhIt == Qt*(1-kHt)/Nt;
E8 = Nt   == Qt*(1-kHt) - Dt;

% For tomorrow
E3p1 = Ptp1   == 1 - xtp2;
E6p1 = cHtp1  == Z + Wh + Wb - (alpha/2)*(kHtp1^2) - Cbtp1;
E7p1 = PhItp1 == Qtp1*(1-kHtp1)/Ntp1;
E8p1 = Ntp1   == Qtp1*(1-kHtp1) - Dtp1;

%% 4. State Eqns.
% 4.1 To be solved.
H(1) = PhIt == (bta/theta)*(1-Pt)*(1-sig + sig*theta*PhItp1)*t1;
H(2) = Ntp1 == sig*Nt*t1 + Wb;
H(3) = 1 == Rt*bta*((1-Pt)*t3 + Pt*xtp1*t4);
H(4) = 1 == bta*((1-Pt)*t3*((Z+Qtp1)/t2) + Pt*t4*((Z+Qrun)/t2));

%% 5. Solve for Rt as ftn of Pt. Substitute in H
Pts = solve(E3,Pt);
H = subs(H,Pt,Pts);

%% 6. Solve for (Ntp1,PhItp1,Qtp1,cHtp1) 
%   w/ [ Nt, PhIt, Pt, Qrun, Qt, cHt, kHt ]
[Np,PhIp,Qp,cHp] = solve(H,[Ntp1,PhItp1,Qtp1,cHtp1]);

%% 6. Solve for (Ptp1, kHtp1)














