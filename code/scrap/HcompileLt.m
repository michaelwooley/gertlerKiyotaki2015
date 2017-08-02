function Hb = HcompileLt( T,include2 ) 
%HcompileLt - Compile H - case x < 1
%   T        - 1x1 - Number of periods until hit SS
%   include2 - 0/1 - whether or not period 2 should be included.

% Build up numeric function
%   initial
if include2 == 1
    % t_init = 2 => use H2lt, adding dummy variable for removed Dt
    Hb = @(z,Qs) H2lt([z(1:2),-1e9,z(3)],z(4:7),Qs);
elseif T == 1
    Hb = @(z,ss,Qs) Hlt(z,ss,Qs);
    return;
else
    % t_init > 2 => Use Hlt
    Hb = @(z,Qs) Hlt(z(1:4),z(5:8),Qs);
end

% t = t_init,...,T-1
for t=2:T-1
    Hb = @(z,Qs) [Hb(z(1:end-4),Qs);...
        Hlt(z(end-7:end-4),z(end-3:end),Qs)];
end

% t = T
Hb = @(z,ss,Qs) [Hb(z,Qs);Hlt(z(end-3:end),ss,Qs)];   

end










