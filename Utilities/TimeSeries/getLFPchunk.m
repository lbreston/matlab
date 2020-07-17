function [Y,t]=getLFPchunk(X,L,k,o,idx)
p=gentimepoints(k,o,L);
tnum=floor(idx/length(p))+1;
ind=mod(idx,length(p))+1;
trial='t'+string(tnum);
range=[p(ind)-floor(k/2),min((p(ind)+floor(k/2)),L)];
%Y=X.(trial)(:,range(1):range(2));
Y=X.(trial);
t=p(ind);
end