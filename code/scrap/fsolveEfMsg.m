function msg = fsolveEfMsg( f )
%fsolveEfMsg - Returns Msg for fsolve exit flag f 
if f == 1
    msg = 'Function converged to a solution x.';
elseif f == 2
    msg = 'Change in x was smaller than the specified tolerance.';
elseif f == 3
    msg = 'Change in the residual was smaller than the specified tolerance.';
elseif f == 4
    msg = 'Magnitude of search direction was smaller than the specified tolerance.';
elseif f == 0
    msg = 'Number of iterations exceeded options.MaxIter or number of function evaluations exceeded options.MaxFunEvals.';
elseif f == -1
    msg = 'Output function terminated the algorithm.';
elseif f == -2
    msg = 'Algorithm appears to be converging to a point that is not a root.';
elseif f == -3
    msg = 'Trust region radius became too small (trust-region-dogleg algorithm).';
elseif f == -4
    msg = 'Line search cannot sufficiently decrease the residual along the current search direction.';
else
    msg = 'Bad input';
end

end

