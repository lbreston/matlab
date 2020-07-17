function [Y, t]=movfun(FuncIn,X,k,o,dim,catdim)
if nargin<5
    dim=ndims(X{1});
end
t=gentimepoints(k,o,length(X{1}));
seg=@(x,t)x(t-floor(k/2):min((t+floor(k/2)),length(x)));
ycell=cell(1,length(t));
for i=1:length(t)
    X_seg=cellfun(@(x)dimfun(@(w)seg(w,t(i)),{x},dim),X,'uniformoutput',false);
    ycell{i}=FuncIn(X_seg{:});
end
if nargin<6
    catdim=ndims(ycell{1})+1;
end
Y=cat(catdim,ycell{:});
end

