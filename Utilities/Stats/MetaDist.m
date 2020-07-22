function [dist]=MetaDist(data,stat,k,dim,precision)
n=10^(precision);
nd=ndims(data);
if isempty(dim)
    dim=nd;
end
if isempty(k)
    k=size(data,dim);
end
distcell=cell(n);
for i=1:n
    S=datasample(data,k,dim);
    distcell{i}=stat(S);
end
  dist = cat(ndims(distcell{1})+1,distcell{:});
end