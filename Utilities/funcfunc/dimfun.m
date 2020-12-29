% dimfun applies an arbitrary function to a chosen dimension of
% multidimensional arrays. If the function requires multiple variable inputs, each input must have its own array. 

% Inputs
% X: a cell array of M, N dimensional, numerical arrays. The arrays must all have the same size
% Dim: Dimension the function is applied to.  The default is the last dimension
% FuncIn: function to be applied to the arrays. FuncIn must be an anonymous functions with M inputs 
 
% Outputs
% Y is an N-1 dimensional array such that
% Y(i1,i2,..i(N-1))=FuncIn(X{1}(i1,i2...i(N)),X{2}(i1,i2...i(N))...X{M}) where i(Dim) = :
% If FuncIn returns a scalar Y is concatenated into a numerical array, otherwise Y is returned as a cell array.


function [Y]=dimfun(FuncIn,X,dim,params)
if nargin<4
    params={};
end
if ~isa(X,'cell')
    X={X};
end
nd=ndims(X{1});
if nargin==2
    dim = nd;
end

Xrd=cellfun(@(x)num2cell(x,dim),X,'UniformOutput',false);
Ycell=cell(size(Xrd{1}));
for i=1:numel(Ycell)
    temp=cellfun(@(x)cellfun(@(y)squeeze(y),x(i),'UniformOutput',false),Xrd);
    Ycell{i}=FuncIn(temp{:},params{:});
end


dlist=1:nd;
sdim=setdiff(dlist,dim);
S(sdim)=size(Ycell,sdim);
S(dim)=numel(Ycell{1});
Y=zeros(S);

idx=cell(1,numel(sdim));
[idx{:}]=ind2sub(S,[1:prod(S)]);
try
for i=1:numel(Ycell)
    for j=1:numel(idx)
        idxtemp(j)=idx{1,j}(i);
    end
    idxtemp2=[num2cell(idxtemp)];
    idxtemp2=[idxtemp2(1:dim-1),':',idxtemp2(dim+1:end)];
    Y(idxtemp2{:})=Ycell{i};
end
catch
    Y=Ycell;
end
end