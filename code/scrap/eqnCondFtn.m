%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Equilibrium Conditions => Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

%%   Four state equations + substitutions
% Define Variables
syms Q_t Kh_t D_t R_t P_t Ch_t Phi_t N_t  ...
    Q_tp1 Kh_tp1 D_tp1 R_tp1 P_tp1 Ch_tp1 Phi_tp1 N_tp1 ...
    Qs qSs KhSs dSs rSs

% Aux. Eqns
x_tp1 = (Z + Qs)*(1-Kh_t)/((Phi_t-1)*N_t*R_t);
Cb_t  = ((1-sig)/sig)*(N_t-Wb);
Cb_tp1  = ((1-sig)/sig)*(N_tp1-Wb);
t1 = (Phi_t*((Z + Q_tp1)/Q_t) - R_t*(Phi_t - 1));

% State Eqns.
H(1,1) = -Phi_t + (beta/theta)*(1-P_t)*...
        (1-sig + sig*theta*Phi_tp1)*t1;
H(2,1) = -N_tp1 + sig*N_t*t1 + Wb;
H(3,1) = -1 + (1-P_t)*R_t*beta*(Ch_t/Ch_tp1) + ...
        P_t*R_t*x_tp1*beta*(Ch_t/Crun);
H(4,1) = -1 + (1-P_t)*beta*(Ch_t/Ch_tp1)*...
       ((Z+Q_tp1)/(Q_t + alpha*Kh_t)) + ...
      P_t*beta*(Ch_t/Crun)*((Z+Qs)/(Q_t + alpha*Kh_t));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Case. x_tp1 < 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Non-state equations
% Subcase. t > 2
E3 = P_t   == 1 - x_tp1;
E6 = Ch_t  == Z + Wh + Wb - (alpha/2)*(Kh_t^2) - Cb_t;
E7 = Phi_t == Q_t*(1-Kh_t)/N_t;
E8 = N_t   == Q_t*(1-Kh_t) - D_t;

% For next period
E6p1 = Ch_tp1  == Z + Wh + Wb - (alpha/2)*(Kh_tp1^2) ...
    - Cb_tp1;
E7p1 = Phi_tp1 == Q_tp1*(1-Kh_tp1)/N_tp1;
E8p1 = N_tp1   == Q_tp1*(1-Kh_tp1) - D_tp1;

% Solve for E[3,6,7,8]
[pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1] = solve(...
    [E3,E6,E7,E8,E6p1,E7p1,E8p1],...
    [P_t,Ch_t,Phi_t,N_t,Ch_tp1,Phi_tp1,N_tp1]);

% Substitute into H()
Hlt = subs(H,...
    [P_t,Ch_t,Phi_t,N_t,Ch_tp1,Phi_tp1,N_tp1],...
    [pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1]);

% Subcase. t = 2
E3 = P_t   == 1 - x_tp1;
E6 = Ch_t  == Z + Wh + Wb - (alpha/2)*(Kh_t^2) - Cb_t;
E7 = Phi_t == Q_t*(1-Kh_t)/N_t;
E8 = N_t   == (1+sig)*Wb;
D2 = D_t   == Q_t*(1-Kh_t) - N_t;

% For next period
E6p1 = Ch_tp1  == Z + Wh + Wb - (alpha/2)*(Kh_tp1^2) ...
    - Cb_tp1;
E7p1 = Phi_tp1 == Q_tp1*(1-Kh_tp1)/N_tp1;
E8p1 = N_tp1   == Q_tp1*(1-Kh_tp1) - D_tp1;

% Solve for E[3,6,7,8] and D2
[pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1,dLt] = solve(...
    [E3,E6,E7,E8,E6p1,E7p1,E8p1,D2],...
    [P_t,Ch_t,Phi_t,N_t,Ch_tp1,Phi_tp1,N_tp1,D_t]);

% Substitute into H()
H2lt = subs(H([1,3,4],1),...
    [P_t,Ch_t,Phi_t,N_t,Ch_tp1,Phi_tp1,N_tp1,D_t],...
    [pLt,ChLt,PhiLt,nLt,ChLtP1,PhiLtP1,nLtP1,dLt]);

% Save Hlt, H2lt as numeric functions 
%   then subs syms on iter
matlabFunction(Hlt,'file','Hlt',...
    'Vars',[Q_t,Kh_t,D_t,R_t,Q_tp1,Kh_tp1,D_tp1,R_tp1,Qs]);
%   Getting rid of D(2)
matlabFunction(H2lt,'file','H2lt',...
    'Vars',[Q_t,Kh_t,R_t,Q_tp1,Kh_tp1,D_tp1,R_tp1,Qs]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Case. x_tp1 > 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Non-state equations
% Subcase. t > 2
E3 = P_t   == 0;
E6 = Ch_t  == Z + Wh + Wb - (alpha/2)*(Kh_t^2) - Cb_t;
E7 = Phi_t == Q_t*(1-Kh_t)/N_t;
E8 = N_t   == Q_t*(1-Kh_t) - D_t;

% For next period
E6p1 = Ch_tp1  == Z + Wh + Wb - (alpha/2)*(Kh_tp1^2) ...
    - Cb_tp1;
E7p1 = Phi_tp1 == Q_tp1*(1-Kh_tp1)/N_tp1;
E8p1 = N_tp1   == Q_tp1*(1-Kh_tp1) - D_tp1;

% Solve for E[3,6,7,8]
[pGt,ChGt,PhiGt,nGt,ChGtP1,PhiGtP1,nGtP1] = solve(...
    [E3,E6,E7,E8,E6p1,E7p1,E8p1],...
    [P_t,Ch_t,Phi_t,N_t,Ch_tp1,Phi_tp1,N_tp1]);

% Substitute into H()
Hgt = subs(H(1:3,1),...
    [P_t,Ch_t,Phi_t,N_t,Ch_tp1,Phi_tp1,N_tp1],...
    [pGt,ChGt,PhiGt,nGt,ChGtP1,PhiGtP1,nGtP1]);

% Subcase. t = 2
E3 = P_t   == 0;
E6 = Ch_t  == Z + Wh + Wb - (alpha/2)*(Kh_t^2) - Cb_t;
E7 = Phi_t == Q_t*(1-Kh_t)/N_t;
E8 = N_t   == (1+sig)*Wb;
D2 = D_t   == Q_t*(1-Kh_t) - N_t;

% For next period
E6p1 = Ch_tp1  == Z + Wh + Wb - (alpha/2)*(Kh_tp1^2) ...
    - Cb_tp1;
E7p1 = Phi_tp1 == Q_tp1*(1-Kh_tp1)/N_tp1;
E8p1 = N_tp1   == Q_tp1*(1-Kh_tp1) - D_tp1;

% Solve for E[3,6,7,8] and D2
[pGt,ChGt,PhiGt,nGt,ChGtP1,PhiGtP1,nGtP1,dGt] = solve(...
    [E3,E6,E7,E8,E6p1,E7p1,E8p1,D2],...
    [P_t,Ch_t,Phi_t,N_t,Ch_tp1,Phi_tp1,N_tp1,D_t]);

% Substitute into H()
H2gt = subs(H,...
    [P_t,Ch_t,Phi_t,N_t,Ch_tp1,Phi_tp1,N_tp1,D_t],...
    [pGt,ChGt,PhiGt,nGt,ChGtP1,PhiGtP1,nGtP1,dGt]);

% Save Hlt, H2lt as numeric functions 
%   then subs syms on iter
matlabFunction(Hgt,'file','Hgt',...
    'Vars',[Q_t,Kh_t,D_t,R_t,Q_tp1,Kh_tp1,D_tp1,R_tp1,Qs]);
% Getting rid of D(2)
matlabFunction(H2gt,'file','H2gt',...
    'Vars',[Q_t,Kh_t,R_t,Q_tp1,Kh_tp1,D_tp1,R_tp1,Qs]);






