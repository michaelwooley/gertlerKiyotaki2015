%% dHcompileLt Test Script

clear all
clc

fprintf('\tdHcompileLt Test Script\n');

T = 5;
include2 = 1;

fprintf('\nCase T = %i, include2 = %i\n',T,include2);

dHO = dHcompileLt( T,include2 );

% Test
Nz = T*4 - 1*(include2 == 1);
zt  = rand(1,Nz);
sst = rand(1,4);
Qst = 0.9;
fprintf('\nWhere is dHb(z,ss,Qs) ~= 0 ?\n');
if T < 11
    fprintf(['\t',repmat('%i ',1,Nz),'\n'],logical(dHO(zt,sst,Qst) ~= 0)');
else
    fprintf('System too big to display AND look good.');
    fprintf('Check w/ small Ts\n');
end




