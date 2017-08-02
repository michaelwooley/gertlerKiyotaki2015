%% backSln Test Script

close all
clear all
clc

% Qrun0 =  0.900882082275617;

Qrun0 = 0.85 + 0.15*rand;
Tol = 1e-8;
maxIter = 1;
nM = 1/48;
maxN2 = 4;
gradAdj = 1.05;
grad0m = 1e-10;

[ sp,Qrm, spOut ] = backSln( Qrun0,Tol,maxIter,nM,maxN2,grad0m,gradAdj );

if isempty(spOut) == 0
    
    plot(spOut(:,5),spOut(:,6));
    plot(spOut(:,5),spOut(:,6))
    hold on
    plot(spOut(:,5),spOut(:,7))
    plot(spOut(1,5),spOut(1,6:7),'yo')
    plot(spOut(2,5),spOut(2,6:7),'go')
    plot(spOut(3,5),spOut(3,6:7),'mo')
    plot(spOut(1:2,5),[spOut(1,6),spOut(2,7)],':')
    plot(spOut(1:2,5),[spOut(1,7),spOut(2,6)],':')    
    hline((1+sig)*Wb,'--')
    axis('tight');
    xlabel('SS Multiplier (grad0m)');
    ylabel('N_2');
    
    % The correct weighting
    [~,m(1),b(1)] = linCoeff( spOut(2:-1:1,5),[spOut(2,7),spOut(1,6)] );
    [~,m(2),b(2)] = linCoeff( spOut(2:-1:1,5),[spOut(2,6),spOut(1,7)] );
    cw = (b(1) - b(2))/(m(2) - m(1));
    
    fprintf('Correct Weighting = %4.3e\n',cw);
    vline(cw,'--');
    
    % Unweighted Mean
    intr = ((1+sig)*Wb - b)./m; 
    vline(mean(intr),'--')
    
%     svStr = {'Q','K^h','D','R','grad0m'};    
%     for i=1:5
%         subplot(3,2,i)
%         plot(spOut(:,i),spOut(:,6))
%         hold on
%         plot(spOut(:,i),spOut(:,7))
%         plot(spOut(1,i),spOut(1,6:7),'yo')
%         plot(spOut(2,i),spOut(2,6:7),'go')
%         plot(spOut(3,i),spOut(3,6:7),'ko')
%         plot(spOut(1:2,i),[spOut(1,6),spOut(2,7)],':')
%         plot(spOut(1:2,i),[spOut(1,7),spOut(2,6)],':')
%         intr(1,i) = interp1(...
%             [spOut(1,7),spOut(2,6)],spOut(1:2,i),(1+sig)*Wb);
%         intr(2,i) = interp1(...
%             [spOut(1,6),spOut(2,7)],spOut(1:2,i),(1+sig)*Wb);
%         vline(mean(intr(:,i)),'--')
%         
%         % Find the correct cross point
%         sLin(i,1,1) = (spOut(1,6) - spOut(2,7))/(spOut(1,i) - spOut(2,i));
%         sLin(i,1,2) = spOut(2,7) - spOut(2,i)*sLin(i,1,1);
%         sLin(i,2,1) = (spOut(1,7) - spOut(2,6))/(spOut(1,i) - spOut(2,i));
%         sLin(i,2,2) = spOut(2,6) - spOut(2,i)*sLin(i,2,1);
%         sCr(i) = (sLin(i,1,2) - sLin(i,2,2))/(sLin(i,2,1) - sLin(i,1,1));
%         disp([svStr{i},'  ',num2str(sCr(i))]);
%         vline(sCr(i))
%         hline((1+sig)*Wb,'--')
%         title(svStr{i});
%     end
    
    % spOut
    disp([1:size(spOut,1);spOut']);

    % Try interpolating
    x = [spOut(1,6),spOut(2,7)];
    v = spOut(1:2,5);               
    disp([spOut(end,5),interp1(x,v,(1+sig)*Wb,'linear')]);

else

    % Check how last period differs wrt different law of motion
    cand = kRootsBack( sp(3,:),Qrm(end),3,(Qrm(end) > qGtMin) );

    disp('Differences in Laws of Motion');
    disp(SvGt2Lt1(sp(3,:),cand,Qrm(end)) - sp(2,:));

    nSs(SvGt2Lt1(sp(3,:),cand,Qrm(end)))

end
% disp(nSs(SvGt2Lt1(sp(3,:),cand,Qrm(end))) - (1+sig)*Wb);
% 
% 
% % Plot only the state variables
% Tplot = size(sp,1);
% Qs = Qrm(end);
% [ ss,uniq,msg ] = ssRoute( Qs,sp(end,:),0.5,0,1 );
% tp = sp(2:end,:);
% 
% TT = 2:Tplot;
% set(groot,'defaultTextInterpreter','latex');
% figure
% subplot(2,2,1)
% hold on
% plot(TT,tp(:,1));
% plot(TT,ones(1,Tplot-1)*ss(1),'--');
% xlim([1,Tplot]);
% title('$Q_t$');
% subplot(2,2,2)
% hold on
% plot(TT,tp(:,2));
% plot(TT,ones(1,Tplot-1)*ss(2),'--');
% title('$K^{h}_t$');
% xlim([1,Tplot]);
% subplot(2,2,3)
% hold on
% plot(TT,tp(:,3));
% plot(TT,ones(1,Tplot-1)*ss(3),'--');
% title('$D_t$');
% xlim([1,Tplot]);
% subplot(2,2,4)
% hold on
% plot(TT,tp(:,4));
% plot(TT,ones(1,Tplot-1)*ss(4),'--');
% title('$\bar{R}_t$');
% xlim([1,Tplot]);

% % for t = 3:Tplot
% %    tp(t,:) =  eqnGt2Lt1( sp(t,:),Qs );
% % end
% % t = 2;
% % tp(t,:) = eqnEq2Lt1(sp(t+1,3),Qs,sp(t+1,1),sp(t,2),sp(t+1,2));
% % tp(1,:) = [];
% % 
% % TT = 2:Tplot;
% % set(groot,'defaultTextInterpreter','latex');
% % figure
% % subplot(3,3,1)
% % hold on
% % plot(TT,tp(:,1));
% % xlim([1,Tplot]);
% % title('$Q_t$');
% % subplot(3,3,2)
% % hold on
% % plot(TT,tp(:,2));
% % title('$K^{h}_t$');
% % xlim([1,Tplot]);
% % subplot(3,3,3)
% % hold on
% % plot(TT,tp(:,3));
% % title('$D_t$');
% % xlim([1,Tplot]);
% % subplot(3,3,4)
% % hold on
% % plot(TT,tp(:,4));
% % title('$\bar{R}_t$');
% % xlim([1,Tplot]);
% % subplot(3,3,5)
% % hold on
% % plot(TT,tp(:,5));
% % title('$P_t$');
% % xlim([1,Tplot]);
% % subplot(3,3,6)
% % hold on
% % plot(TT,tp(:,6));
% % title('$N_t$');
% % xlim([1,Tplot]);
% % subplot(3,3,7)
% % hold on
% % plot(TT,tp(:,7));
% % title('$\Phi_t$');
% % xlim([1,Tplot]);
% % subplot(3,3,8)
% % hold on
% % plot(TT,tp(:,8));
% % title('$C^h_t$');
% % xlim([1,Tplot]);
% % subplot(3,3,9)
% % hold on
% % plot(TT,tp(:,9));
% % title('$C^b_t$');
% % xlim([1,Tplot]);
% % 



