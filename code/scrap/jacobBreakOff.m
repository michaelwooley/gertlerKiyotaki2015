%% Test if can take W/Jacobian just once 
%    then break off pieces
%   CONCLUSION: Yes.

clear all
clc

Qs = 0.9;
ss = [1,1,1,1];

Ts = 25;

% Define Symbolic Matrices
Q = sym('Q',[1 Ts]);
Kh = sym('Kh',[1 Ts]);
D = sym('D',[1 Ts]);
R = sym('R',[1 Ts]);

%% "Initial" W/Jacobian
% Stack the conditions in W, 
%   save the parameters in the best order possible.
% For t=2
W = H2lt(Q(2),Kh(2),D(2),R(2),Q(3),Kh(3),D(3),R(3),Qs);
% For t=3..T-1
for t=3:Ts-1
   W = [W;Hlt(Q(t),Kh(t),D(t),R(t),...
       Q(t+1),Kh(t+1),D(t+1),R(t+1),Qs)];
end
% For t=T
W = [W;Hlt(Q(Ts),Kh(Ts),D(Ts),R(Ts),...
    ss(1),ss(2),ss(3),ss(4),Qs)];

% Well-formatted arguments for taking jacobian
G = reshape([Q(2:end);Kh(2:end);D(2:end);R(2:end)],1,[]);

% Jacobian
dW = jacobian(W,G);

%% Next Period
% For t=2
Wn = Hlt(Q(3),Kh(3),D(3),R(3),Q(4),Kh(4),D(4),R(4),Qs);
% For t=3..T-1
for t=4:Ts-1
   Wn = [Wn;Hlt(Q(t),Kh(t),D(t),R(t),...
       Q(t+1),Kh(t+1),D(t+1),R(t+1),Qs)];
end
% For t=T
Wn = [Wn;Hlt(Q(Ts),Kh(Ts),D(Ts),R(Ts),...
    ss(1),ss(2),ss(3),ss(4),Qs)];

% Well-formatted arguments for taking jacobian
Gn = reshape([Q(3:end);Kh(3:end);D(3:end);R(3:end)],1,[]);

% Jacobian
dWn = jacobian(Wn,Gn);

%% Test
all(all(dW(5:end,5:end) == dWn))






