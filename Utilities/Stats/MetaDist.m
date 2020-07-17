function [dist]=MetaDist(data,stat,k,dim,precision)
n=10^(precision);
nd=ndims(data);
if isempty(dim)
    dim=nd;
end
if isempty(k)
    k=size(data,dim);
end
dSize=size(data);
dSize(dim)=n;
dist=zeros(dSize);
for i=1:n
    S=datasample(data,k,dim);
    slice = repmat({':'},1,n);
    slice{dim}=i;
    dist(slice{:})=stat(S);
end
end