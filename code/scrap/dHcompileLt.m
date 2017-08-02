function dHb = dHcompileLt( T,include2 )
%dHcompileLt - Compile dHb - case x < 1

Nz = T*4 - 1*(include2 == 1);

% t = t_init
if T ~= 1 && include2 == 1
    dHb = @(z,Qs) [dH2lt([z(1:2),-1e9,z(3)],z(4:7),Qs),zeros(3,Nz-7)];
    it = 3;
elseif T == 1 && include2 == 1
    fprintf('No. That''s a stupid choice. Return null.\n'); 
    dHb = null;
    return;
elseif T == 1 && include2 == 0
    dHb = @(z,ss,Qs) sparse(dHltLast(z,ss,Qs));
    return;
elseif  T ~= 1 && include2 == 0
    dHb = @(z,Qs) [dHlt(z(1:4),z(5:8),Qs),zeros(4,Nz-8)];
    it = 4;
else
    fprintf('Error\n');
    return;
end
    
% t = t_init+1,...,T-1
for t=2:T-1
    
    dht = @(v,Qs) [zeros(4,it),dHlt(v(1:4),v(5:8),Qs),zeros(4,Nz-it-8)];
    dHb = @(z,Qs) [dHb(z(1:end-4),Qs);dht(z(end-7:end),Qs)];
    it = it + 4;
    
end

% t = T, T ~= 1
dhl = @(v,ss,Qs) [zeros(4,Nz-4),dHltLast(v,ss,Qs)];
dHb = @(z,ss,Qs) sparse([dHb(z(1:end),Qs);dhl(z(end-3:end),ss,Qs)]);

end

