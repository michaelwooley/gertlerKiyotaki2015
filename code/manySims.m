%% manySims - Carry out many simulations to compute stats on stats

clear all

ns = 1000;  % Number of simulations
TT = 5000;  % Number of periods in each simulation
V  = 0; 

fprintf('\nmanySims:\n');
fprintf('\tNumber of Simulations            = %i\n',ns);
fprintf('\tNumber of Periods per Simulation = %i\n',TT);

for i=1:ns
    [~,avgSS(i,1),avgRT(i,1)] = simuPath( TT,120,V );
    [~,avgSS(i,2),avgRT(i,2)] = simuPath( TT,[],V );
end

fprintf('Cut\t\t120\t\t170\n');
fprintf('avgSS\t%3.2f\t%3.2f\n',mean(avgSS(:,1)),mean(avgSS(:,2)));
fprintf('     \t(%3.2f)\t(%3.2f)\n',std(avgSS(:,1)),std(avgSS(:,2)));
fprintf('avgRT\t%3.2f\t%3.2f\n',mean(avgRT(:,1)),mean(avgRT(:,2)));
fprintf('     \t(%3.2f)\t(%3.2f)\n',std(avgRT(:,1)),std(avgRT(:,2)));

