%% ssLtFind Test Script

clear all
clc

% Test first on Q* = 0.9
Qs = 0.92;
s0 = [0,0,0,0];
w = 1;
V = 1;
Cons = 1;

[ s90,uniq ] = ssFindLt( Qs,s0,w,V,Cons );

% USED to have trouble here:
Qs = 0.80;
s0 = s90;
w = 1;
V = 1;
Cons = 1;

[ s,uniq ] = ssFindLt( Qs,s0,w,V,Cons );

% Now try it with weighting
Qs = 0.95;
s0 = s90;
w = 0.95;
V = 1;
Cons = 1;

[ s95,uniq ] = ssFindLt( Qs,s0,w,V,Cons );

% No trouble here:
Qs = 0.995;
s0 = s95;
w = 0.95;
V = 1;
Cons = 1;

[ s995,uniq ] = ssFindLt( Qs,s0,w,V,Cons );

% Has trouble here:
Qs = 0.9999;
s0 = s995;
w = 0.95;
V = 1;
Cons = 1;

[ s,uniq ] = ssFindLt( Qs,s0,w,V,Cons );

% Try turning off constraints
Qs = 0.9999;
s0 = s995;
w = 1;
V = 1;
Cons = 0;

[ s,uniq ] = ssFindLt( Qs,s0,w,V,Cons );