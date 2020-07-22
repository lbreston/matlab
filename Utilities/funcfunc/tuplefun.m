% tuplefun applies a function to all the permutations of slices of M multidimensional arrays 

% Inputs
% X: a cell array of M numerical arrays. 
% Dim: Dimension along which the arrays are sliced 
% FuncIn: function to be applied to the permutations of slices. Must be an anonymous functions with M inputs. Has outputs of size S
% cell: If true tuplefun returns a cell array of results. Otherwise it returns a numerical array. The default is false
% FuncOut: 1x2 cell array of functions for indexing the outputs of FuncIn.
% FuncOut{1} converts the outputs of FuncIn to a cell array.
% FuncOut{2} generates an array of indicies such that Z(FuncOut{2}(i))=FuncOut{1}{i})
% This is useful to take advandage of redundant function outputs 

% Ouputs
% Z is an M+S dimensional numerical array or M dimensional cell array. 
% if cell is true Z{i1,i2,...i(M)}=FuncIn(X{1}(i1),X{2}(i2)...X{M}) where X{j}(i) is the ith slice of X{j} along the Dim dimension. 
% if cell is false Z(i1,i2,...i(M),S)=FuncIn(X{1}(i1),X{2}(i2)...X{M}) where X{j}(i) is the ith slice of X{j} along the Dim dimension.

% Example
% If X={X1,X2} with sizes R1xC1, R2xC2 respectively 
% if Dim = 1 size(Z) = [R1,R2,...] and Z(i,j,...)=FuncIn(X1(i,:),X2(j,:))
% if Dim = 2 size(Z) = [C1,C2,...]  Z(i,j,...)=FuncIn(X1(:,i),X2(:,j)) 


function [Z]=tuplefun(FuncIn,X,dim,cellout,FuncOut)
if nargin<5
    outY=@(w){w};
    outI=@(z,s)sub2ind(s,z(1),z(2));
else
    outY=FuncOut{1};
    outI=FuncOut{2};
end
if nargin<4
    cellout=false;
end

S=cellfun(@(x)size(x,dim),X,'UniformOutput',true);
Y=cell(S);
idx=cell(1,numel(X));
[idx{:}]=ind2sub(size(Y),[1:numel(Y)]);
Xsplit=cellfun(@(x)slice(x,dim),X,'UniformOutput',false);
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

if cellout
    Z=Y;
    return
end

Z=zeros([S,size(Y{1})]);
for i=1:numel(Y)
    for j=1:numel(idx)
        idxtemp(j)=idx{1,j}(i);
    end
    idxtemp2=[num2cell(idxtemp),':'];
    Z(idxtemp2{:})=Y{i};
end

end

