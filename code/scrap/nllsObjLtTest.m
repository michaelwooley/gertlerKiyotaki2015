%% nllsObjLt Test Script
clear all
clc

T = 120;
t0 = 3;%2*( T~= 1) + 1*( T == 1);
include2 = 1*(t0 == 2 && T ~= 1);
Qs = 0.95;
ss = [1.06654221800968,...
    0.354278685854880,...
    0.677818630533251,...
    1.01133755161957];

% Set up z
srun = [Qs,0,1,1/beta];
gw = 0.3;
grid = gw*(((T-(1:T))./T)*( T ~= 1 ) + 1*( T == 1 ));
z = kron(1-grid,ss) + kron(grid,srun);
if include2 == 1 && T ~= 1
    z(3) = [];
end

% Set up funcs
Ht = HcompileLt( T,include2 );
dHt = dHcompileLt( T,include2 );

tic;
[val,J] = nllsObjLt( z,Ht,dHt,Qs,ss,t0,T );
toc

val



