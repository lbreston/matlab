%Aligns two lists of time stamps according to their difference in time
%Inputs: Two row vectors of timestamps ts1 and ts2
%output: 2 x max(length of ts1,length of ts2) array. The frist row contains the
%values of ts1, second row contains the values of ts2. The values of the
%of the row corresponding to the longer list are aligned with the
%closet values from the shorter list. 


function alignedtimes = timealigner(ts1,ts2)

[tslong,tsshort,rowlong] = orderbylength(ts1,ts2);
rowshort=setdiff([1,2],rowlong);

alignedtimes=zeros(2,length(tslong));
alignedtimes(rowlong,:)=tslong;

frame=1;

for i=1:length(tslong)
    
    nextframe=min(frame+1,length(tsshort));

    tdiffframe=abs(tslong(i)-tsshort(frame));
    tdiffnextframe=abs(tslong(i)-tsshort(nextframe));
    
    if tdiffframe>tdiffnextframe
        frame=nextframe;
    end
    
    alignedtimes(rowshort,i)=tsshort(frame);
end

end

function [long,short,indlong] = orderbylength(x,y)
if length(x)>=length(y)
    long=x;short=y;indlong=1;
else
    long=y;short=x;indlong=2;
end
end


       
    