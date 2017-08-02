%% Test Script for HcompileLt

clear all
clc

fprintf('\tTest Script for HcompileLt\n');

% Case w/o period 2 and T > 1
T = 50;
include2 = 0;

fprintf('Case T = %i\tinclude2 = %i\n',T,include2);
HbOut = HcompileLt( T,include2 );

% Number of variables TBD
Nz = T*4 - 1*(include2 == 1);

% Test
fprintf('\tTests for stacked equations H\n\n');
zt  = rand(1,Nz);
sst = rand(1,4);
Qst = 0.9;

fprintf('Expected Size of output = %i x %i\n',Nz,1);
fprintf('Size of output          = %i x %i\n',size(HbOut(zt,sst,Qst)));

td = [(1:Nz)',kron((3:T+2)',ones(4,1)),HbOut(zt,sst,Qst)]';
fprintf('\nTest Hb(z,ss,Qs) Function:\n');
fprintf('Eqn #\tt+\tH(z,ss,Qs)\n');
fprintf('%i\t\t%i\t%.0f\n',td(:));

% Case WITH period 2
T = 50;
include2 = 1;

fprintf('\nCase T = %i\tinclude2 = %i\n',T,include2);
HbOut = HcompileLt( T,include2 );


% Number of variables TBD
Nz = T*4 - 1*(include2 == 1);

% Test
fprintf('\tTests for stacked equations H\n\n');
zt  = rand(1,Nz);
sst = rand(1,4);
Qst = 0.9;

fprintf('Expected Size of output = %i x %i\n',Nz,1);
fprintf('Size of output          = %i x %i\n',size(HbOut(zt,sst,Qst)));

td = [(1:Nz)',[2*ones(3,1);kron((3:T+1)',ones(4,1))],HbOut(zt,sst,Qst)]';
fprintf('\nTest Hb(z,ss,Qs) Function:\n');
fprintf('Eqn #\tt\tH(z,ss,Qs)\n');
fprintf('%i\t\t%i\t%.0f\n',td(:));

% Case w/o period 2 and T = 1
T = 1;
include2 = 0;

fprintf('Case T = %i\tinclude2 = %i\n',T,include2);
HbOut = HcompileLt( T,include2 );

% Number of variables TBD
Nz = T*4 - 1*(include2 == 1);

% Test
fprintf('\tTests for stacked equations H\n\n');
zt  = rand(1,Nz);
sst = rand(1,4);
Qst = 0.9;

fprintf('Expected Size of output = %i x %i\n',Nz,1);
fprintf('Size of output          = %i x %i\n',size(HbOut(zt,sst,Qst)));

td = [(1:Nz)',kron((3:T+2)',ones(4,1)),HbOut(zt,sst,Qst)]';
fprintf('\nTest Hb(z,ss,Qs) Function:\n');
fprintf('Eqn #\tt+\tH(z,ss,Qs)\n');
fprintf('%i\t\t%i\t%.0f\n',td(:));