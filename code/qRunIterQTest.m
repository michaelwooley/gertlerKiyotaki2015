%% qRunIterQ Test Script

% close all
% clear all
% clc

Qri = 0.85 + 0.1*rand;
fprintf('Q* = %4.3f\n',Qri);
grad0m = 1e-10;
gradAdj = 1.05;

[ spp,spInfo,flag ] = qRunIterQ( Qri,grad0m,gradAdj );

[adjust,adjI] = min(abs(spInfo(3,7:8) - (1+sig)*Wb));
if adjI == 1
    fprintf('N_2 Difference: %3.2f%%\n',100*log(spInfo(3,7)/((1+sig)*Wb)));
else
    fprintf('N_2 Difference: %3.2f%%\n',100*log(spInfo(3,8)/((1+sig)*Wb)));
end

