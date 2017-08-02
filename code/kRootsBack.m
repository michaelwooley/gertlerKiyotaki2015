function root = kRootsBack( stp1,Qrun,t,gtlt )
%kRootsBack - Finds solution to kHt via roots of eqn.
%   root = kRootsBack( stp1,Qrun,t,gtlt )

% Get coefficients by case.
if t > 2 && gtlt == 0
    c = KcGt2Lt1(stp1,Qrun);
elseif t > 2 && gtlt == 1
    c = KcGt2Gt1(stp1,Qrun);
elseif t == 2 && gtlt == 0
    c = KcEq2Lt1(stp1,Qrun);
elseif t == 2 && gtlt == 1
    c = KcEq2Gt1(stp1,Qrun);
else
   fprintf('ERROR: t = %i, gtlt = %i not a valid case.\n',t,gtlt); 
   root = NaN;
   return;
end

% Find roots
rc = roots(c);

% Check condition
rcgt0lt1 = ((rc >= 0) & (rc <= 1));

if sum(rcgt0lt1) > 1
    
    % Get coefficients by case.
    if t > 2 && gtlt == 0
        cd = KdcGt2Lt1(stp1,Qrun);
    elseif t > 2 && gtlt == 1
        cd = KdcGt2Gt1(stp1,Qrun);
    elseif t == 2 && gtlt == 0
        cd = KdcEq2Lt1(stp1,Qrun);
    elseif t == 2 && gtlt == 1
        cd = KdcEq2Gt1(stp1,Qrun);
    else
       fprintf('ERROR: t = %i, gtlt = %i not a valid case.\n',t,gtlt); 
       root = NaN;
       return;
    end
    
    % Find Roots
    rcd = roots(cd);
    % Check condition
    rcdgt0lt1 = ((rcd >= 0) & (rcd <= 1));
    rcd2 = setdiff(find(rcgt0lt1 > 0),find(rcdgt0lt1 > 0));
    if length(rcd2) > 1
%        fprintf('ERROR: More than one root.\n');
       root = rc(rcd2);
    else
       root = rc(rcd2);
    end
    
elseif sum(rcgt0lt1) == 0
%    fprintf('\nERROR: No roots found.\n');
   root = NaN;   
else
   root = rc(rcgt0lt1); 
end



end

