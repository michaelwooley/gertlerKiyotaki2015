%% SS Test Script

% Test SS solver
clear all
clc


Qs = 0.8;   % Sample Q*
s0 = [0.055,0.31,0.2,1.04,0.5,0.5,0.5,0.5]; % Initial guess
V = 1;
r = 1;

[ ss,Qs ] = xLt1SS( Qs,s0,r,V );




