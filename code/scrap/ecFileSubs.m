function ecFileSubs( file )
%ecFileSubs - Regex substitution for ec* files

fm = [file,'.m'];
% Change inputs
find_and_replace(fm,...
    [file,'\(Qt,kHt,Dt,Rt,Qtp1,kHtp1,Dtp1,Rtp1,Qs\)'],...
    [file,'(sT,sTp1,Qs)']);

find_and_replace(fm,'\(QT,KHT,DT,RT,QTP1,KHTP1,DTP1,RTP1,QS\)','(sT,sTp1,Qs)');
% Rename t+1 arguments to prevent confusion
find_and_replace(fm,'Qtp1'    ,'aaaa');
find_and_replace(fm,'k[hH]tp1','bbbb');
find_and_replace(fm,'Dtp1'    ,'cccc');
find_and_replace(fm,'Rtp1'    ,'dddd');
% Replace date t arguments
find_and_replace(fm,'Qt'  ,'sT(1)');
find_and_replace(fm,'kHt' ,'sT(2)');
find_and_replace(fm,'Dt'  ,'sT(3)');
find_and_replace(fm,'Rt'  ,'sT(4)');
% Replace date t+1 arguments
find_and_replace(fm,'aaaa','sTp1(1)');
find_and_replace(fm,'bbbb','sTp1(2)');
find_and_replace(fm,'cccc','sTp1(3)');
find_and_replace(fm,'dddd','sTp1(4)');

end

