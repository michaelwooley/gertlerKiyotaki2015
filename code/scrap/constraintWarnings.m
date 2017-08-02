function constraintWarnings( ss )
%constraintWarnings - Warnings when model constraints violated.

if xSs(ss) > 1
    fprintf('WARNING: x = %3.2f > 1.\n',xSs(ss));
end

if nSs(ss) < 0
    fprintf('WARNING: N = %3.2f < 0.\n',nSs(ss));
end

if PhiSs(ss) < 0
    fprintf('WARNING: Phi = %3.2f < 0.\n',PhiSs(ss));
end

if CbSs(ss) < 0
    fprintf('WARNING: Cb = %3.2f < 0.\n',CbSs(ss));
end

if MLNdSs(ss) < 0
    fprintf('WARNING: Max Leverage failure.\n');
end

if MLNdSs(ss) > theta
    fprintf('WARNING: No default failure.\n');  
end

if ss(1) < 0
    fprintf('WARNING: Q = %3.2f < 0.\n',ss(1));
end

if ss(2) < 0
    fprintf('WARNING: Kh = %3.2f < 0.\n',ss(2));
end

if ss(3) < 0
    fprintf('WARNING: D = %3.2f < 0.\n',ss(3));
end

if ss(4) < 0
    fprintf('WARNING: R = %3.2f < 0.\n',ss(4));
end

end

