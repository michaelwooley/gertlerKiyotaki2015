%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This is an Example Call of MIDACO 4.0
%     -------------------------------------
%
%     MIDACO solves the general Mixed Integer Non-Linear Program (MINLP):
%
%
%       Minimize     F(X)           where X(1,...N-NI)   is *CONTINUOUS*
%                                   and   X(N-NI+1,...N) is *DISCRETE* 
%
%       Subject to:  G_j(X)  =  0   (j=1,...ME)     Equality Constraints
%                    G_j(X) >=  0   (j=ME+1,...M) Inequality Constraints
%
%       And bounds:  XL <= X <= XU
%
%
%     The problem statement of this example is given below in the function
%     '[f,g] = problem_function(x)'. You can use this example as a template to 
%     run MIDACO on your own problem. In order to do so: Replace the objective 
%     function 'F' (and in case the constraints 'G') given below with your own 
%     problem functions. Then simply follow the instruction steps 1 to 3 given 
%     in this file. 
%
%     See the MIDACO Header and MIDACO User Guide for more information.
%
%     Author(C): Dr. Martin Schlueter           
%                Information Initiative Center,
%                Division of Large Scale Computing Systems,
%                Hokkaido University, Japan.
%
%        Email:  info@midaco-solver.com
%        URL:    http://www.midaco-solver.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function example_MINLPc
  clear all; clear mex; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Specify MIDACO License-Key
  key = 'MIDACO_LIMITED_VERSION___[CREATIVE_COMMONS_BY-NC-ND_LICENSE]';        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: Problem definition     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 1.A : Define name of problem function (by function handle symbol '@')
  problem.func = @problem_function; % Call is: [f,g] = problem_function(x) 
  
% Step 1.B : Define problem dimensions
  problem.n  = 4; % Number of variables (in total)
  problem.ni = 2; % Number of integer variables (0 <= nint <= n)
  problem.m  = 3; % Number of constraints (in total)
  problem.me = 1; % Number of equality constraints (0 <= me <= m)
     
% Step 1.C : Define lower and upper bounds 'xl' and 'xu' for 'x'
  problem.xl   = 1 * ones(1,problem.n);
  problem.xu   = 4 * ones(1,problem.n); 

% Step 1.D : Define starting point 'x'
  problem.x  = problem.xl; % Here for example: 'x' = lower bounds 'xl'
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2: Choose stopping criteria and printing options    %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 2.A : Decide maximal runtime by evalution and time budget
  option.maxeval  = 10000;  % Maximum number of function evaluation (e.g. 1000000)
  option.maxtime  = 60*60*24; % Maximum time limit in Seconds (e.g. 1 Day = 60*60*24)

% Step 2.B : Choose printing options
  option.printeval  = 1000;   % Print-Frequency for current best solution (e.g. 1000)
  option.save2file  = 1;      % Save SCREEN and SOLUTION to TXT-files [ 0=NO/ 1=YES]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3: Choose MIDACO parameters (ONLY FOR ADVANCED USERS)    %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  option.param(1) =  0;  %  ACCURACY      (default value is 0.001)
  option.param(2) =  0;  %  RANDOM-SEED   (e.g. 1, 2, 3,... 1000)
  option.param(3) =  0;  %  FSTOP
  option.param(4) =  0;  %  AUTOSTOP      (e.g. 1, 5, 20, 100,... 500) 
  option.param(5) =  0;  %  ORACLE 
  option.param(6) =  0;  %  FOCUS         (e.g. +/- 10, 500,... 100000) 
  option.param(7) =  0;  %  ANTS          (e.g. 2, 10, 50, 100,... 500)
  option.param(8) =  0;  %  KERNEL        (e.g. 2, 5, 15, 30,... 100) 
  option.param(9) =  0;  %  CHARACTER
  
% Note: The default value for all parameters is 0.   
%       See the MIDACO User Manual for more details.  

  option.parallel =  0;  %  See the MIDACO homepage for this option
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Call MIDACO solver   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [ solution ] = midaco( problem, option, key);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   End of Example    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Small example test problem (replace f and g() with your own problem) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ f, g ] = problem_function( x )

% Objective function value F(X) (denoted here as 'f')
  f = (x(1)-1)^2 ...
    + (x(2)-2)^2 ...
    + (x(3)-3)^2 ...
    + (x(4)-4)^2 ...
    + 1.23456789;

% Equality constraints G(X) = 0 MUST COME FIRST in g(1:me)
  g(1) = x(1) - 1;
% Inequality constraints G(X) >= 0 MUST COME SECOND in g(me+1:m)
  g(2) = x(2) - 1.333333333;
  g(3) = x(3) - 2.666666666;

return
%%%%%%%%%%%%%%%%%%
%  end of file   %
%%%%%%%%%%%%%%%%%%