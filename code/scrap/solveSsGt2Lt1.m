%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Steady State Solution in One Variable. Case t > 2, xtp1 < 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

%% 1. Define Variables
syms Qt kHt Dt Rt Pt cHt PhIt Nt ...
     Qtp1 kHtp1 Dtp1 Rtp1 Ptp1 cHtp1 PhItp1 Ntp1 ...
     Qs 

%% 2. Aux. Eqns
xtp1 = (Z + Qs)*(1-kHt)/((PhIt-1)*Nt*Rt);
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
E6p1 = cHtp1  == Z + Wh + Wb - (alpha/2)*(kHtp1^2) - Cbtp1;
E7p1 = PhItp1 == Qtp1*(1-kHtp1)/Ntp1;
E8p1 = Ntp1   == Qtp1*(1-kHtp1) - Dtp1;

%% 4. State Eqns.
% 4.1 To be solved
H(1) = PhIt == (beta/theta)*(1-Pt)*(1-sig + sig*theta*PhItp1)*t1;
H(2) = Ntp1 == sig*Nt*t1 + Wb;
H(3) = 1 == Rt*beta*((1-Pt)*t3 + Pt*xtp1*t4);

% 4.2 To be substituted into.
K = -1 + beta*((1-Pt)*t3*((Z+Qtp1)/t2) + Pt*t4*((Z+Qs)/t2));

%% 5. Manipulations
% Solve for E[3,6,7,8]
[pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1] = solve(...
    [E3,E6,E7,E8,E6p1,E7p1,E8p1],...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1]);

% Substitute into H()
Hs = subs(H,...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1],...
    [pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1]);

% SS - Substitute 'tp1' variables for 't' variables
Hss = subs(Hs,[Qtp1,kHtp1,Dtp1,Rtp1],[Qt,kHt,Dt,Rt]);

% Solve Hss
[Qk,kHk,Rk] = solve(Hss,[Qt,kHt,Rt]);

% Substitute all into Hs
Ks = subs(K,...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1],...
    [pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1]);

% SS - Second substitution of 'tp1' variables for 't' variables
Kss = subs(Ks,[Qtp1,kHtp1,Dtp1,Rtp1],[Qt,kHt,Dt,Rt]);

Kkss = subs(Kss,[Qt,Dt,Rt],[Qk,Dk,Rk]);

%% 6. Create Vector Function that maps to steady state vector
Fk(1) = Qk;
Fk(2) = kHt;
Fk(3) = Dk;
Fk(4) = Rk;
ssV(Dtp1, Qs, Qtp1, kHt, kHtp1) = Fk;

%% 8. Create Functions
%   NOTE: 'Optimize', true was not working.
%   Probably because file Kk.m is 372k!

% THE function
matlabFunction(Kkss,'File','Kkss','Optimize',false);

% State Vector
matlabFunction(ssV,'File','ssV','Optimize',false);




