%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Forwards Solution. Case t > 2, xtp1 < 1
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
H(1) = PhIt == (beta/theta)*(1-Pt)*(1-sig + sig*theta*PhItp1)*t1;
H(2) = Ntp1 == sig*Nt*t1 + Wb;
H(3) = t2   == beta*((1-Pt)*t3*(Z+Qtp1) + Pt*t4*(Z+Qrun));
H(4) = 1    == Rt*beta*((1-Pt)*t3 + Pt*xtp1*t4);

%% 5. Manipulations
% Solve for E[3,6,7,8]
[pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1] = solve(...
    [E3,E6,E7,E8,E6p1,E7p1,E8p1],...
    [Pt,cHt,PhIt,Nt,cHtp1,PhItp1,Ntp1]);

% Substitute into H
Hs = subs(H,[Pt,PhItp1],[pLt,PhiLtP1]);

% Solve H
[Qkp,cHkp,Nkp,Rk] = solve(Hs,[Qtp1,cHtp1,Ntp1,Rt]);

% %% 6. Make Functions
% vOut = {[Nt,PhIt,Qt,Rt,cHt,kHt,Pt],Qrun};
% 
% % State Vars
% matlabFunction(Ns,PhIs,Qs,cHs,'File','SvFsGt2Lt1','Vars',vOut);
% % kHs
% matlabFunction(kHs,'File','KhFsGt2Lt1');
% % Others
% matlabFunction(Ps,Rs,Ds,'File','OvFsGt2Lt1');








