%% linCoeff Test Script

close all
clear all
clc

x = [1,2];
y = [1,2];

[f,m,b] = linCoeff( x,y );

ezplot(f,[0,2]);

x = [1,2];
y = [2,2];

[f,m,b] = linCoeff( x,y );

ezplot(f,[0,2]);

