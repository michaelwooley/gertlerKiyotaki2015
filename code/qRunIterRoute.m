function [ spp,spInfo,flag ] = qRunIterRoute( M,Qri,grad0m,gradAdj )
%qRunIterRoute - Sends to chosen interpolation method

if M == 1
    [ spp,spInfo,flag ] = qRunIter( Qri,grad0m,gradAdj );
else
    [ spp,spInfo,flag ] = qRunIterQ( Qri,grad0m,gradAdj );
end


end

