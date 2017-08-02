%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% HcompileLtProto - Compile H - case x < 1 - Prototype
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

fprintf('epMatCompileLt\n');

% Specify steps to SS from shock
Ts = 25;
Nz = (Ts-1)*4 + 3;

fprintf('\tTs = %i\tNz = %i\n',Ts,Nz);

% Build up numeric function
% t = 2 => use H2lt, adding dummy variable for removed Dt
Hb = @(z,Qs) H2lt([z(1:2),-1e9,z(3)],z(4:7),Qs);
% t = 3,4,...,Ts-1
for t=2:Ts-1
    Hb = @(z,Qs) [Hb(z(1:end-3),Qs);Hlt(z(end-7:end-4),z(end-3:end),Qs)];
end
% t = Ts
Hb = @(z,ss,Qs) [Hb(z(1:end-3),Qs);Hlt(z(end-3:end),ss,Qs)];

% Test
fprintf('\tTests for stacked equations H\n');
zt  = rand(1,Nz);
sst = rand(1,4);
Qst = 0.9;

td = [(1:Nz)',[2*ones(3,1);kron((3:Ts+1)',ones(4,1))],Hb(zt,sst,Qst)]';
fprintf('\nTest Hb(z,ss,Qs) Function:\n');
fprintf('Eqn #\tt\tH(z,ss,Qs)\n');
fprintf('%i\t\t%i\t%.0f\n',td(:));


% See if Matlab Optimization speeds things up...
fprintf('Attempting to optimize via matlabFunction\n');
zs = sym('zs',[1 Nz]);
sss = sym('sss',[1 Nz]);
Qss = sym('Qss',[1 1]);

Hbs = Hb(zs,sss,Qss);
vs = {zs,sss,Qss};
matlabFunction(Hbs,'File','Hbsn','Vars',vs);


Nt = 1000;
zt  = rand(Nt,Nz);
sst = rand(Nt,4);
Qst = 0.9;


fprintf('\nSpeed Trials for \n');
fprintf('Nt = %i\tNz = %i\tTs = %i\n',Nt,Nz,Ts);
for i=1:Nt
    
    zti = zt(i,:);
    ssti = sst(i,:);
    
    t1 = tic;
    Hb(zti,ssti,Qst);
    toc1(i) = toc(t1);
    t2 = tic;
    Hbsn(zti,ssti,Qst);
    toc2(i) = toc(t2);
    
end

fprintf('Mean( Hb )   = %3.2e\n',mean(toc1));
fprintf('Mean( Hbsn ) = %3.2e\n',mean(toc2));
% Seems that Hb is somewhat faster!
%   For Ns = 5
% Mean( Hb )   = 9.72e-05
% Mean( Hbsn ) = 1.24e-04
%   For Ns = 15
% Mean( Hb )   = 2.93e-04
% Mean( Hbsn ) = 4.15e-04
% Nt = 1000	Nz = 99	Ts = 25
% Mean( Hb )   = 4.21e-04
% Mean( Hbsn ) = 8.34e-04











