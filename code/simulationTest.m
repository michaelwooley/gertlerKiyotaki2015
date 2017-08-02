%% simulation Test Script

close all
clear all
clc

TT = 5000;
% Run a bunch to check for bugs
for i=1:500
    [sim,avgSS,avgRT] = simuPath( TT,120 );
end
% plot(sim(:,end-1));


