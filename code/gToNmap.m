%% gToNmap - Generate Figure showing mapping of grad0m to N_2

close all
clear all
clc

Qri = 0.93;%max(min(0.9 + 0.05*randn,0.98),0.8);
fprintf('Qri = %4.3f\n',Qri);
s0 = zeros(1,4);
w = 1;
V = 0;
Cons = 1;
[ ss,uniq,msg ] = ssRoute( Qri,s0,w,V,Cons );
if uniq ~= 1; 
    disp(msg);
    return;
end

ssj = SvJLt( ss,Qri );

sZg = 65;
gradBegin = 1e-10;
grad0m = linspace(gradBegin,1e-10*1.35,sZg);

for i = 1:sZg
    [ sp{i},flag ] = backSolve( ss,grad0m(i),ssj,Qri );
    sZsp(i) = size(sp{i},1);
    fprintf('i = %i\tLength = %i\n',i,size(sp{i},1));
end

mxt = max(sZsp);
mnt = min(sZsp);

for i = 1:sZg
    n2i(i,:) = [ grad0m(i),nSs(sp{i}(1,:)),nSs(sp{i}(2,:)),sZsp(i) ];
end

% Plot
set(0,'defaultTextInterpreter','latex');
figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
hold on
for i=mxt:-1:mnt
    idx = find(n2i(:,4) == i);
    po = plot( n2i(idx,1),n2i(idx,2), 'o' );
    pt = plot( n2i(idx,1),n2i(idx,3), '^' );
    pt.Color = po.Color;
    text(n2i(idx(2),1)*1.005,n2i(idx(2),2),...
        ['$\leftarrow$ ',int2str(i),' steps'],...
        'interpreter','latex','FontSize',5);
end
text(n2i(idx(end),1)*0.95,n2i(idx(end),2)*1.05,...
    {'Circles o are last','steps for each $\gamma$.'},...
    'interpreter','latex','FontSize',5);
text(n2i(idx(1),1)*1.01,n2i(idx(1),3)*1.005,...
    {'Triangles $\triangle$ are next-to-last',...
    'steps for each $\gamma$.'},...
    'interpreter','latex','FontSize',5);
hline((1+sig)*Wb,'--');
set(axes1,'YTick',[-0.001 0 0.000224 0.001 0.002],'YTickLabel',...
    {'-0.001','0','(1+\sigma)W^b','0.001','0.002'});
xlabel('$\gamma$','interpreter','latex');
ylabel(['Net Worth $N_t$ given $Q^* = $',num2str(Qri)],...
    'interpreter','latex');
% leg = legend('$N_{end}$','$N_{end-1}$');
% leg.Interpreter = 'latex';
matlab2tikz('paperObjects/gToNmap.tex');



