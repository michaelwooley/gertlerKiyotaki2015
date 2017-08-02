%% backSln Test Script
% nohup matlab -nosplash -nodisplay -nodesktop -r 
%   backSlnTest > backSlnTestLog.txt

clear all
clc

Qrun0 = 0.80:0.05:1.0;
Tol = 1e-12;
maxIter = 25;

parfor i=1:length(Qrun0)
    [ sp{i},Qrm{i} ] = backSln( Qrun0(i),Tol,maxIter );
end

save('backSlnTestMat.mat','sp','Qrm','Qrun0','maxIter','Tol'); 
% exit;
