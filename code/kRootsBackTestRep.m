%% kRootsBack Test Script

clear all
close all
clc

% Use some old results
load('backSlnTestMat.mat');

% Narrow focus
Qrm = Qrm{3};
Qrun = Qrm(end);
sp = sp{3};

%% Ex. 1 - Use the SS from backSlnMat
gtlt = 0;
lsp = size(sp,1);

for t = lsp:-1:3

stp1 = sp(t,:);
root = kRootsBack( stp1,Qrun,t,gtlt );
disp([vpa(root - sp(t-1,2)),root > sp(t,2)]);

end

% The solution is increasing (as it should).
%   kRootsBack Returns slightly different roots.
%   CONCLUDE: Problem not coming from kRootsBack

%% Ex. 2 - Generate Own SS and state vector

sp2(lsp,:) = ssFindLt( Qrun,zeros(1,4),0.5,1,1 );
disp(vpa(sp2(lsp,:) - sp(lsp,:)));


for t = lsp:-1:3
    
   stp2 = sp2(t,:);
   root = kRootsBack( stp2,Qrun,t,gtlt );
   
   disp(vpa([root,sp(t-1,2)]));
   disp(root - sp(t-1,2));
   disp(root > sp2(t,2));
   disp(root - sp2(t,2));
   sp2(t-1,:) = SvGt2Lt1(sp2(t,3),Qrun,sp2(t,1),root,sp2(t,2));
   disp(sp2(t-1,:) - sp(t-1,:));
   gtlt = (xSs(sp2(t-1,:),Qrun) >= 1);
   
end

% The solution is DECREASING

%% Ex. 3 - Generate Only Own State Vector
clear sp2
sp2(lsp,:) = sp(lsp,:);

for t = lsp:-1:3
    
   stp2 = sp2(t,:);
   root = kRootsBack( stp2,Qrun,t,gtlt );
   disp(root - sp(t-1,2))
   disp(root > sp2(t,2));
   sp2(t-1,:) = SvGt2Lt1(sp2(t,3),Qrun,sp2(t,1),root,sp2(t,2));
  
end

% The solution is INcreasing (as it should)
%   CONCLUDE: Problem is coming from ssFindLt











