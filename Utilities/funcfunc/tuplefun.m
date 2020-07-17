function [Z]=tuplefun(FuncIn,X,dim,FuncOut)

if nargin<4
    outY=@(w){w};
    outI=@(z,s)sub2ind(s,z(1),z(2));
else
    outY=FuncOut{1};
    outI=FuncOut{2};
end
nd=ndims(X{1});
dlist=1:nd;
sdim=setdiff(dlist,dim);
S=cellfun(@(x)size(x,sdim),X,'UniformOutput',true);
Y=cell(S);
Z=[];
idx=cell(1,numel(X));
[idx{:}]=ind2sub(size(Y),[1:numel(Y)]);
Xsplit=cellfun(@(x)num2cell(x,dim),X,'UniformOutput',false);
for i=1:numel(Y)
    if isempty(Y{i})
        for j=1:numel(Xsplit)
            xtemp{j}=Xsplit{1,j}{idx{1,j}(i)};
            idxtemp(j)=idx{1,j}(i);
        end
        oI=outI(idxtemp,S);
        oY=outY(FuncIn(xtemp{:}));
        for k=1:numel(oI)
            Y{oI(k)}=oY{k};
        end
    end
    
end

Z=zeros([S,numel(Y{2})]);
for i=1:numel(Y)
    for j=1:numel(idx)
        idxtemp(j)=idx{1,j}(i);
    end
    idxtemp2=[num2cell(idxtemp),':'];
    Z(idxtemp2{:})=Y{i};
end

end

