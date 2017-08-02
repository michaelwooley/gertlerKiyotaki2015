%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% dHcompileLtProto - Compile dH - case x < 1 - Prototype
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MWE of built-up dH matrix. Ts = 4 - [t1,t2,t3,t4] = [run,nr,nr,nr]
%     H1a H1b H1d H2a H2b H2c H2d H3a H3b H3c H3d
% Q1   1   1   1   0   0   0   0   0   0   0   0 
% K1   1   1   1   0   0   0   0   0   0   0   0   
% R1   1   1   1   0   0   0   0   0   0   0   0
% Q2   2   2   2   2   2   2   2   0   0   0   0
% K2   2   2   2   2   2   2   2   0   0   0   0
% D2   2   2   2   2   2   2   2   0   0   0   0
% R2   2   2   2   2   2   2   2   0   0   0   0
% Q3   0   0   0   3   3   3   3   3   3   3   3
% K3   0   0   0   3   3   3   3   3   3   3   3
% D3   0   0   0   3   3   3   3   3   3   3   3
% R3   0   0   0   3   3   3   3   3   3   3   3

clear all
clc

fprintf('dHcompileLt\n');
% Specify steps to SS from shock
Ts = 3;
Nz = (Ts - 1)*4 + 3;

fprintf('\tTs = %i\tNz = %i\n',Ts,Nz);

% Build up numeric function
fprintf('\tTests for Jacobian dH\n');
% t = 2 => use H2lt, adding dummy variable for removed Dt
dHb = @(z,Qs) [dH2lt([z(1:2),-1e9,z(3)],z(4:7),Qs)';zeros(Nz-7,3)];
% logical(dHb(ones(1,7),0.9) ~= 0)  % Test

% t = 3,4,...,Ts-1
for t=2:Ts-1
    
    it  = 3+4*(t-2);
    dht = @(z,Qs) [zeros(it,4);dHlt(z(1:4),z(5:8),Qs)';zeros(Nz-it-8,4)];
    dHb = @(z,Qs) [dHb(z(1:end-3),Qs),dht(z(end-7:end),Qs)];
%     size(dHb(ones(1,it+8),0.9))  % Test
end
% t = Ts
dhLast = @(zt,ss,Qs) [zeros(Nz-4,4);dHltLast(zt,ss,Qs)];
dHb = @(z,ss,Qs) [dHb(z(1:end),Qs),dhLast(z(end-3:end),ss,Qs)];
% size(dHb(ones(1,Nz),ones(1,4),0.9))  % Test

% Test
zt  = rand(1,Nz);
sst = rand(1,4);
Qst = 0.9;

fprintf('\nWhere is dHb(z,ss,Qs) ~= 0 ?\n');
if Ts < 11
    fprintf(['\t',repmat('%i ',1,Nz),'\n'],logical(dHb(zt,sst,Qst) ~= 0));
else
    fprintf('System too big to display AND look good.');
    fprintf('Check w/ small Ts\n');
end


