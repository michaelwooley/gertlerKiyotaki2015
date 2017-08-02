function s0 = ssLtInitDraw( Qs )
%ssLtInitDraw - Draw a permissable s0 to initiate fsolve.

T = 25;
t = 0;
while t < T
    
    rw  = rand(1,2);  % Random weights
    Kh0 = rand(1,1);  % Draw Kh    
    x0  = rand(1,1);  % Draw x0
    
    RB0 = @(D) (Z+Qs)*(1-Kh0)/(D*x0);
    Cb0 = rw(1)*(Z + Wh + Wb - (alpha/2)*(Kh0)^2);
    Q0  = @(D) (D + Wb + (sig/(1-sig))*Cb0)/(1-Kh0);
    
    F = @(D) Z + Q0(D) - RB0(D)*Q0(D) - rw(2)*theta*Q0(D);
    D0 = fsolve(F,0.5,optimset('display','off'));
    
    
    s = [Q0(D0),Kh0,D0,RB0(D0)];
    test = ssLtNlCon( s,Qs );
    
    if test == 1
        s0 = s;
        t = T + 100;
        return;
    elseif t < T - 1
        t = t + 1;
    else
        fprintf('No s0 found in 25 tries. Return NaN.\n');
        s0 = NaN;
        t = T+100;
        return;
    end
    
end

end

