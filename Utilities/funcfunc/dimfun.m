function [Z]=dimfun(FuncIn,X,dim)
nd=ndims(X{1});
if nargin==2
    dim = nd;
end

Xrd=cellfun(@(x)num2cell(x,dim),X,'UniformOutput',false);
Ycell=cell(size(Xrd{1}));
for i=1:numel(Ycell)
    temp=cellfun(@(x)cellfun(@(y)squeeze(y),x(i),'UniformOutput',false),Xrd);
    Ycell{i}=FuncIn(temp{:});
end


dlist=1:nd;
sdim=setdiff(dlist,dim);
S(sdim)=size(Ycell,sdim);
S(dim)=numel(Ycell{1});
Z=zeros(S);

idx=cell(1,numel(sdim));
[idx{:}]=ind2sub(S,[1:prod(S)]);
try
for i=1:numel(Ycell)
    for j=1:numel(idx)
        idxtemp(j)=idx{1,j}(i);
    end
    idxtemp2=[num2cell(idxtemp)];
    idxtemp2=[idxtemp2(1:dim-1),':',idxtemp2(dim+1:end)];
    Z(idxtemp2{:})=Ycell{i};
end
catch
    Z=Ycell;
end
end