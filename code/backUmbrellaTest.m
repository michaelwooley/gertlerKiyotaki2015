%% backUmbrella Test Script

close all
clear all
clc

M = 2;
Tol = 1e-8;
maxIter = 100;
grad0m = 1e-8;
gradAdj = 1.025;
V = 1;
Q0 = 0.98;
[ sp,Qrm ] = backUmbrella( Q0,Tol,maxIter,grad0m,gradAdj,M,V );

% 0.98
% grad0m = 1e-5
% Quadratic
% Q* = 0.9008719788

% 0.98
% grad0m = 1e-8
% Quadratic
% Q* = 0.9008716263

% 0.84
% grad0m = 1e-8
% Quadratic
% Q* = 0.9008696946

% 0.84
% grad0m = 1e-8
% Linear
% Q* = 0.9007625555

% Differences in 'Quadratic' v. 'linear' seem to be drawn by fact
%   that more data is available, not that it is picking up
%   curvature. i.e. there IS curvature but there seems to 
%   be a greater gain from getting a closer local interpolation
%   than from the data concerning curvature that the additional 
%   points provide.
