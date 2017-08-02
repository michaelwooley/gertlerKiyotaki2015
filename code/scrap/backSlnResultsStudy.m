%% backSln Results Study

clear all
close all
clc

load('backSlnTestMat.mat');

N0 = length(Qrun0);

% Plot each result
set(0,'defaultLineMarkerSize',2);
figure('name','Qrm, by Qrun0');
hold on
for i=1:N0
   qri = Qrm{i};
   p(i) = plot(qri(1:end-1),qri(2:end),'-o',...
       'DisplayName',num2str(Qrun0(i)));
end
legend(p,'location','southeast');

% What happens at 0.89?

[ ~,Qrm89 ] = backSln( 0.89,Tol,maxIter);

figure('name','Qrm at Q*_0 = 0.89');
hold on
plot(Qrm89(3:end-1),Qrm89(4:end),'-o');
text(Qrm89(3:end-1),Qrm89(4:end),strsplit(int2str(3:24)));


% All together
% Plot each result
set(0,'defaultLineMarkerSize',2);
figure('name','Qrm, by Qrun0');
hold on
for i=1:N0
   qri = Qrm{i};
   p(i) = plot(qri(1:end-1),qri(2:end),'-o',...
       'DisplayName',num2str(Qrun0(i)));
end
p(i+1) = plot(Qrm89(3:end-1),Qrm89(4:end),'-o',...
    'DisplayName','0.89');
legend(p,'location','southeast');










