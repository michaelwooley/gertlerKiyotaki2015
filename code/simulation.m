function sim = simu( T )
%simulation - simulate the path of the economy

% Load data
load('simData.mat');

pth2 = [pth;ss];

% sizes
pl = size(pth2,1);

% Probability of a run
pr = @(z) 1 - min((Z + Qrun)*(1-z(2))/(z(3)*z(4)),1);

% Make draws
draws = rand(T+1,1);

% Set up output matrix
% sim_t = [Q,K,D,R,P,draw,path-status]
sim = -1000*ones(T+1,7);

% Initial Path status - at SS
ps = pl;

% Initial period - at SS
ps
size(pth2)
pr(pth2(ps,:))
sim(1,:) = [pth2(ps,:),pr(pth2(ps,:)),0,ps]

% Iterate
for t=1:T
    
    % next path state
    ps
    min(ps+1,pl)
    nps = pth2(min(ps+1,pl),:)
    
    if pr(nps) > draws(t+1)  % A run
        
        ps = 1; % Back to run period
  
    else                    % Not a run
        
        ps = min(ps+1,pl);
        
    end
    
    sim(t+1,1:4) = [pth2(ps,:),pr(nps),draws(t+1),ps];
    
end




end

