function [ ss,uniq,msg ] = ssRoute( Qrun,s0,w,V,Cons )
%ssRoute - Get SS conditional on Qrun

if Qrun < qGtMin
    [ ss,uniq,msg ] = ssFindLt( Qrun,s0,w,V,Cons );
else
    ss   = ssGt;
    uniq = 1;
    msg  = 'No Run SS returned';
end



end

