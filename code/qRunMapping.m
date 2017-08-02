%% Q* Mapping graph creation script

clear all

M = 2;
Tol = 1e-8;
maxIter = 100;
grad0m = 1e-8;
gradAdj = 1.05;
V = 0;

Q0 = 0.98;
[ sp,Qrm ] = backUmbrella( Q0,Tol,maxIter,grad0m,gradAdj,M,V );

Q02 = 0.8;
[ sp2,Qrm2 ] = backUmbrella( Q02,Tol,maxIter,grad0m,gradAdj,M,V );

% Plot out convergence of Q*
figure('name','Q* Mapping');
hold on
set(0,'defaultTextInterpreter','latex');
p98 = plot(Qrm(1:end-1),Qrm(2:end));
p80 = plot(Qrm2(1:end-1),Qrm2(2:end));
p80.Color = p98.Color;
plot(Q02:1e-2:Q0,Q02:1e-2:Q0,'--'); % 45 degree line
plot([Qrm2(end),Qrm2(end)],[Qrm2(1),Qrm(1)],':');
text(Qrm2(end),Qrm2(end)*0.97,...
    ['$Q^*_{eqn.} = ',num2str(Qrm(end)),'$'],...
    'interpreter','latex');
xlabel('$Q^*$ - Guess');
ylabel('$Q^*$ - Update');

