%% eqnPathFigure - Create Figure of Equilibrium Paths

clear all

% Find equilibrium path
M = 2;
Tol = 1e-8;
maxIter = 200;
grad0m = 1e-8;
gradAdj = 1.002;
V = 1;
Q0 = 0.9014;
[ sp,Qrm ] = backUmbrella( Q0,Tol,maxIter,grad0m,gradAdj,M,V );

Qs = Qrm(end);
% Find Associated SS
s0 = sp(end,:);
w = 1;
V = 1;
Cons = 1;
[ ss,uniq ] = ssFindLt( Qs,s0,w,V,Cons );
ss = eqnGt2Lt1( ss,Qs );

% Make the full path (state + non-state variables)
Tplot = 60;%size(sp,1);
% t > 2;
for t = 3:Tplot
   tp(t,:) =  eqnGt2Lt1( sp(t,:),Qs );
end
% t = 2
t = 2;
tp(2,:) = eqnGt2Lt1( sp(t,:),Qs );%eqnEq2Lt1(sp(t+1,:),sp(t,2),Qs);
% t = 1
% P(run) = 0, Phi(run) = 0 [no deposits], Ch(run) = Crun, 
%   Cb(run) = 0 [those who exit have N=0] 
tp(1,:) = [sp(1,:),0,Wb,0,Crun,0];
tp(1,:) = [];

TT = 2:Tplot;
set(groot,'defaultTextInterpreter','latex');
figure
subplot(3,3,1)
hold on
plot(TT,tp(:,1));
hline(ss(1))
xlim([1,Tplot]);
title('$Q_t$');
subplot(3,3,2)
hold on
plot(TT,tp(:,2));
hline(ss(2))
title('$K^{h}_t$');
xlim([1,Tplot]);
subplot(3,3,3)
hold on
plot(TT,tp(:,3));
hline(ss(3))
title('$D_t$');
xlim([1,Tplot]);
subplot(3,3,4)
hold on
plot(TT,tp(:,4));
hline(ss(4))
title('$\bar{R}_t$');
xlim([1,Tplot]);
subplot(3,3,5)
hold on
plot(TT,tp(:,5));
hline(ss(5))
title('$P_t$');
xlim([1,Tplot]);
subplot(3,3,6)
hold on
plot(TT,tp(:,6));
hline(ss(6))
title('$N_t$');
xlim([1,Tplot]);
subplot(3,3,7)
hold on
plot(TT,log(tp(:,7)));
hline(log(ss(7)))
title('$\log (\Phi_t$)');
xlim([1,Tplot]);
subplot(3,3,8)
hold on
plot(TT,tp(:,8));
hline(ss(8))
title('$C^h_t$');
xlim([1,Tplot]);
subplot(3,3,9)
hold on
plot(TT,tp(:,9));
hline(ss(9))
title('$C^b_t$');
xlim([1,Tplot]);
