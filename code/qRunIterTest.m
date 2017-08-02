%% qRunIter Test Script

close all
clear all
clc

Qri = 0.85 + 0.1*rand;
fprintf('Q* = %4.3f\n',Qri);
grad0m = 1e-10;
gradAdj = 1.05;

[ spp,spInfo ] = qRunIter( Qri,grad0m,gradAdj );

figure
hold on
plot( ones(1,2)*spInfo(1,6),spInfo(1,7:8) ,'o');
plot( ones(1,2)*spInfo(2,6),spInfo(2,7:8) ,'o');
plot( ones(1,2)*spInfo(3,6),spInfo(3,7:8) ,'o');
plot( spInfo(1:2,6),[spInfo(1,7),spInfo(2,8)],'--');
plot( spInfo(1:2,6),[spInfo(1,8),spInfo(2,7)],'--');
plot( spInfo(:,6),spInfo(:,7) );
plot( spInfo(:,6),spInfo(:,8) );
hline((1+sig)*Wb,'k:')
[adjust,adjI] = min(abs(spInfo(3,7:8) - (1+sig)*Wb));
fprintf('N_2 Difference: %4.3e\n',adjust);

% % Ex. 2 Does using old results speed up new?
% 
% % Initial
% Qri = 0.90;
% fprintf('Q* = %4.3f\n',Qri);
% grad0m = 1e-10;
% gradAdj = 1.05;
% [ spp,spInfo ] = qRunIter( Qri,grad0m,gradAdj );
% [adjust,adjI] = min(abs(spInfo(3,7:8) - (1+sig)*Wb));
% fprintf('N_2 Difference: %4.3e\n',adjust);
% 
% for i = 1:15
%     Qri = Qri - 1e-5;
%     fprintf('Q* = %4.3f\n',Qri);
%     grad0m = spInfo(3,6);
%     gradAdj = 1.05*(adjI == 1) + 0.95*(adjI == 2);
%     [ spp,spInfo ] = qRunIter( Qri,spInfo(3,6),gradAdj );
%     [adjust,adjI] = min(abs(spInfo(3,7:8) - (1+sig)*Wb));
%     fprintf('N_2 Difference: %4.3e\n',adjust);
% end


% s0 = zeros(1,4);
% w = 1;
% V = 0;
% Cons = 1;
% [ ss,~,~ ] = ssRoute( Qri,s0,w,V,Cons );
% svStr = {'Q','K^h','D','R'};
% TT = {2:(size(spp{1},1)+1),2:(size(spp{2},1)+1)};
% figure
% for i=1:4
%     subplot(2,2,i);
%     hold on
%     plot(TT{1},spp{1}(:,i),TT{2},spp{2}(:,i));
%     hline(ss(i));
%     title(svStr{i});
% end
% 


