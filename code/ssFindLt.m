function [ s,uniq,msg,fh,cond ] = ssFindLt( Qrun,s0,w,V,Cons )
%ssLtFind - Function for finding SS vectors
%   Qrun  - 1x1 - Q* at which to find SS vector
%   s0    - 1x4 - Vector at which to begin search
%   w     - 1x1 - Weight on random draw v. s0 
%   V     - 0/1 - Verbose
%   Cons  - 0/1 - Analytic Constraints (default - on)

% How many s0 to consider
T = 100;
% How many slns to find before returning
Ns = 1;
% How many times to try to do weighting
Ns0 = 15;
% Try it on s0 once if can't weight
s0try = 0;
% Let weighting degrade
w0 = max(0,min(1,w))*ones(1,4);
% Set default Constraints == On
if isempty(Cons); Cons = 1;end

fpfv(V,'Searching for SS with x < 1 and Q* = %3.2f\n',Qrun);
if Cons == 0
   fpfv(V,'\n\tWARNING: x < 1 Constraint OFF.\n'); 
end

% Objective
HHlt = @(s) HssLt( s,Qrun );

% Optimization Options
opt = optimset('display','off','TolX', 1e-34);

% init storage
sln = -100*ones(T,4);
s00  = -100*ones(T,4);
cond = zeros(T,1);
t = 1;
suc = 0;

while (suc < Ns) && (t < T)
    
    % Draw initial guess
    w = w0*((T-t)/T) + ones(1,4)*(1-((T-t)/T));
    s0t = ssLtInitDraw( Qrun ).*w + s0.*(1-w);
    if isnan(s0t) == 1
        suc = Ns + 100;
        t = T + 100;
        s = s0t;
        uniq = 0;
        msg = 'Bad';
        fh = NaN;
        cond = 0;
        return;
    elseif ssLtNlCon( s0t,Qrun ) == 0
        j = 0;
        while (j < Ns0) && (ssLtNlCon( s0t,Qrun ) == 0)
            s0t = ssLtInitDraw( Qrun ).*w + s0.*(1-w); 
            j = j+1;
        end
        % See if worked:
        if ssLtNlCon( s0t,Qrun ) == 0
            if s0try == 0
                if ssLtNlCon( s0,Qrun ) == 1
                    s00(t,:) = s0;
                    s0try = 1;
                else
                    fpfv(V,'\tWarning: s0 bad at iter %i.',t);
                    fpfv(V,' Setting w = 1\n');
                    s00(t,:) = ssLtInitDraw( Qrun );
                    s0try = 1;
                end
            else
                fpfv(V,'\tWarning: s0 bad at iter %i.',t);
                fpfv(V,' Setting w = 1\n');
                s00(t,:) = ssLtInitDraw( Qrun );
            end
        end
    else
        s00(t,:) = s0t;
    end
     
    % Solve
    [sln(t,:),~,ef] = fsolve( HHlt,s00(t,:),opt);
       
    snn = sln(t,:);
    
    % Don't count bad exits
    if ef < 1;  
        t = t + 1;
        continue;
    end
    
    % If constraints on
    if Cons == 1
        % Test for constraints
        if ssLtNlCon( snn,Qrun ) == 1
            suc = suc + 1;
            cond(t) = 1;
        end
    else
        suc = suc + 1;
        [cc,c] = ssLtNlCon( snn,Qrun );
        if cc == 1
            cond(t) = 1;
        elseif c(7) == 1
            cond(t) = 2;
        else
            cond(t) = 0;
        end
    end
    t = t+1;
end
fpfv(V,'Done Searching for Solutions.\n');
fpfv(V,'%i/%i Solutions Found in %i iterations.\n',...
    suc,Ns,t);

% Test for (numeric) equality of proposed solutions.
ic = find(cond ~= 0);
lc = length(ic);
if sum(cond) > 0
    msd = zeros(lc);
    for i=1:lc;
        ii = ic(i);
        for j=min(i+1,lc):lc
            jj = ic(j);
            msd(i,j) = max((sln(ii,:) - sln(jj,:)).^2);
        end
    end
    fpfv(V,'Max Sq. Difference Among Candidate Slns\n');
    fpfv(V,'\t = %3.2e\n',max(msd(:)));
    
    % Check if returned solution unique or not
    if max(msd(:)) < 1e-8
        uniq = 1;
        s = sln(ic,:);
        fpfv(V,'SS unique.\n');
        fpfv(V,'Max Residual of State Eqns. at SS: %3.2e\n\n',...
            max(HssLt(s,Qrun)));
        msg = 'good.';                             
        fh = HssLt(s,Qrun);
        cond = cond(ic(1));
        return;
    else
        fpfv(V,'SS Non-unique.\n');
        fpfv(V,'Evaluating All Candidates in State Eqns\n');
        fh = [];
        for i=1:lc
            ssn = sln(ic(i),:);
            fpfv(V,'Candidate SS #%i.\n, Condition = %i',i,cond(ic(i)));
            fpfv(V,'\tQ\tKh\tD\tR\n');
            fpfv(V,'\t%3.2f\t%3.2f\t%3.2f\t%3.2f\n',ssn);
            fpfv(V,'\tMax Residual = %3.2e\n',max(HssLt(ssn,Qrun)));
            fh = [fh;max(HssLt(ssn,Qrun))];
        end
        s = sln(ic,:);
        uniq = 0;
        msg = 'non-unique.';
        cond = cond(ic);
        return;
    end
else       
    fpfv(V,'SS NOT FOUND. Returning NaN.\n\n');
    msg = 'No slns found.';
    s = NaN;
    fh = NaN;
    uniq = 0;
    return;
end





end

