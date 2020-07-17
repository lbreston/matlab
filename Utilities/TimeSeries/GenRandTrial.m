function [trial]=GenRandTrial(D,avgL)
numvar=size(D,1);
t=randi(length(D)-avgL,1,numvar);
trial=[];
for j=1:size(D,1)
    trial=[trial;D(j,t(j):t(j)+avgL)];
end
end