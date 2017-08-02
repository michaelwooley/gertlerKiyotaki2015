function [sim,avgSS,avgRT] = simuPath( T,cut,V )
%simulation - simulate the path of the economy

% Load data
load('simData.mat');

% sizes
pl = size(pth,1);

if isempty(cut) == 0
   pth = pth([1:cut,pl],:);
   pl =  size(pth,1);
end

% Probability of a run
pr = @(z) 1 - min((Z + Qrun)*(1-z(2))/(z(3)*z(4)),1);

% Make draws
draws = rand(T+1,1);

% Set up output matrix
% sim_t = [Q,K,D,R,P,draw,path-status]
sim = -1000*ones(T+1,8);

% Initial Path status - at SS
ps = pl;

% Initial period - at SS
sim(1,:) = [pth(ps,:),pr(pth(ps,:)),0,ps,1];

% Iterate
for t=1:T
    
    % next path state
    nps = pth(min(ps+1,pl),:);
    
    if pr(nps) > draws(t+1)  % A run
        
        ps = 1; % Back to run period
  
    else                    % Not a run
        
        ps = min(ps+1,pl);
        
    end
    
    sim(t+1,:) = [pth(ps,:),pr(nps),draws(t+1),ps,t+1];
    
end

SSbeg = [1;intersect(find(sim(:,end-1) == pl-1) + 1,...
    find(sim(:,end-1) == pl))];
SSend = intersect(find(sim(:,end-1) == 1) - 1,...
    find(sim(:,end-1) == pl));
if sim(T+1,end-1) == pl
    SSend = [SSend;T+1];
end

if length(SSbeg) ~= length(SSend)
length(SSbeg)
length(SSend)

if length(SSbeg) < length(SSend)
    disp([[SSbeg;-100],SSend]);
else
    disp([SSbeg,[SSend;-100]]);
end
    
plot(sim(:,end-1));
hold on
plot(SSbeg,ones(length(SSbeg))*pl,'*');
plot(SSend,ones(length(SSend))*pl,'o');
end


avgSS = mean(SSend - SSbeg + 1);  % Average Time in SS

run = find(sim(:,end-1) == 1);
for i=2:length(SSbeg)
   
    ri = min(run(run > SSbeg(i-1)));
    
    rs(i-1,:) = [ri,SSbeg(i)]; 
    
end

avgRT = mean(diff(rs'));

fpfv(V,'\n\tsimuPath\n');
fpfv(V,'Simulation Periods           = %i\n',T);
fpfv(V,'SS cut-off                   = %i\n',pl);
fpfv(V,'Avg. Periods in SS           = %3.2f\n',avgSS);
fpfv(V,'Avg. Periods to Return to SS = %3.2f\n',avgRT);
fpfv(V,'Number of Runs               = %i\n',length(run));
fpfv(V,'Number of SS Returns         = %i\n',length(SSbeg)-1);

end

