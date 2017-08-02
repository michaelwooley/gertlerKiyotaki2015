%% SvJlt Test Script

clear all
clc

% Set example
Qrun = 0.91;

ss = ssFindLt( Qrun,zeros(1,4),1,1,1 );

% By itself
tic
SvJLt( ss,Qrun )
toc

(SvJLt( ss,Qrun )*ones(5,1)*1e-5)'



tic
SvJLt( ss,Qrun )
toc

