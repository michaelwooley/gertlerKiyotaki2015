%% backSolve Test Script

close all
clear all
clc

fprintf('\t~~ backSolveTest ~~\n');

% % Ex. 1 - Proof of operation
% fprintf('FIND SS\n');
% Qri = 0.85 + 0.1*rand;
% s0 = zeros(1,4);
% w = 1;
% V = 1;
% Cons = 1;
% [ ss,~,~ ] = ssRoute( Qri,s0,w,V,Cons );
% 
% fprintf('FIND Gradient\n');
% ssj = SvJLt( ss,Qri );
% 
% fprintf('\nRUN backSolve\n');
% grad0m = 1e-10;
% fprintf('grad0m = %4.3e\tQri = %4.3f\n',grad0m,Qri);

% [ sp,flag ] = backSolve( ss,grad0m,ssj,Qri );

% svStr = {'Q','K^h','D','R'};
% TT = 2:(size(sp,1)+1);
% figure
% for i=1:4
%     subplot(2,2,i);
%     hold on
%     plot(TT,sp(:,i));
%     hline(ss(i));
%     title(svStr{i});
% end
% 
% % Ex. 2 Relationship between grad0m and N_2
% 
% Qri = max(min(0.9 + 0.05*randn,0.98),0.8);
% fprintf('Qri = %4.3f\n',Qri);
% s0 = zeros(1,4);
% w = 1;
% V = 0;
% Cons = 1;
% [ ss,uniq,msg ] = ssRoute( Qri,s0,w,V,Cons );
% if uniq ~= 1; 
%     disp(msg);
%     return;
% end
% 
% ssj = SvJLt( ss,Qri );
% 
% sZg = 20;
% grad0m = linspace(1e-10,1e-10*1.05,sZg);
% 
% for i = 1:sZg
%     [ sp{i},flag ] = backSolve( ss,grad0m(i),ssj,Qri );
%     sZsp(i) = size(sp{i},1);
%     fprintf('i = %i\tLength = %i\n',i,size(sp{i},1));
% end
% 
% mxt = max(sZsp);
% mnt = min(sZsp);
% 
% for i = 1:sZg
%     if sZsp(i) == mxt
%         n2i(i,:) = [ grad0m(i),nSs(sp{i}(1,:)),sZsp(i) ];
%     elseif sZsp(i) == mnt
%         n2i(i,:) = [ grad0m(i),nSs(sp{i}(1,:)),sZsp(i) ];
%     else
%        fprintf('Length neither max/min\n');
%        return;
%     end
% end
% 
% % Plot
% figure
% hold on
% plot( n2i(:,1),n2i(:,2), 'o' );
% hline((1+sig)*Wb,'--');
% 
% % Correlation
% fprintf('\tCorr( grad0m,N_2 ) = %4.3e\n',corr(n2i(:,1),n2i(:,2)));
% 
% % Fitting - leave every other out
% [~,P1] = evalc('polyfit( n2i(1:2:sZg,1),n2i(1:2:sZg,2),1 )');
% [~,P2] = evalc('polyfit( n2i(1:2:sZg,1),n2i(1:2:sZg,2),2 )');
% 
% for i=2:2:sZg
%     fmt = [i,...
%         (n2i(i,2) - polyval(P1,n2i(i,1))).^2,...
%         (n2i(i,2) - polyval(P2,n2i(i,1))).^2];
%     
%     fprintf('%i\t%3.2e\t%3.2e\n',fmt);
% end
% clear fmt
% 
% svStr = {'Q','K^h','D','R'};
% figure
% hold on
% for i=1:sZg
%     plot(sp{i}(:,4));
% end
% hline(ss(4));
% title(svStr{4});

% % Ex. 3 Try interp1 with the same from above
% 
% % With all points
% g3 = interp1(n2i(:,2),n2i(:,1),(1+sig)*Wb,'linear');
% [ sp3,flag ] = backSolve( ss,g3,ssj,Qri );
% fprintf('All Points: %4.3e\n',nSs(sp3(1,:)) - (1+sig)*Wb);
% 
% % With just first and last points
% idx = [1,sZg];
% g3f = interp1(n2i(idx,2),n2i(idx,1),(1+sig)*Wb,'linear');
% [ sp3f,flag ] = backSolve( ss,g3f,ssj,Qri );
% fprintf('First/Last Points: %4.3e\n',nSs(sp3f(1,:)) - (1+sig)*Wb);

% Ex. 4 How steps change
Qri = max(min(0.9 + 0.05*randn,0.98),0.8);
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
grad0m = linspace(1e-6,1e-6*1.35,sZg);

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
figure
hold on
plot( n2i(:,1),n2i(:,2), 'o' );
plot( n2i(:,1),n2i(:,3), '^' );
hline((1+sig)*Wb,'--');

Qri = max(min(0.9 + 0.05*randn,0.98),0.8);
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
grad0m = linspace(1e-6,1e-6*1.35,sZg);

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
plot( n2i(:,1),n2i(:,2), 'o' );
plot( n2i(:,1),n2i(:,3), '^' );
hline((1+sig)*Wb,'--');

svStr = {'Q','K^h','D','R'};
figure
hold on
for i=1:sZg
    plot(sp{i}(:,4));
end
hline(ss(4));
title(svStr{4});




