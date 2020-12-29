% Concatenates the leaves of a tree along the dim dimension
 
% Inputs:
% X: struct with tree topology  
% dim: concatenation dimension. The default value is ndim(X.(leaf))+1 where (leaf) is the 
% r: if r is true catleaves will be recursively run until its output is an array 
 
% Outputs
% Y: tree struct with same fields as X of depth-1 
% Y.(leaf) = cat(X.(leaves),dim)
% If the dimensions of the leaves are consistent Y.(leaf) will be a numerical array, otherwise it will be a cell array. 
% if r is true Y will return an array of the recursively concatenated fields of X.  


function Y=catleaves(X,dim,r)
if nargin < 3
    r=false;
end
if nargin<2
    dim=[];
end
if r
    Y=X;
    while isa(Y,'struct')
        Y=ctlv(Y,dim);
    end
else
    Y=ctlv(X,dim);
end

end


function Y=ctlv(X,dim)
fields=fieldnames(X);
stest=cellfun(@(x)isa(X.(x),'struct'),fields);
try
    assert(~any(stest));
    ytemp = struct2cell(X);
    if isempty(dim)
        dim=ndims(ytemp{1})+1;
    end
    try
        Y = cat(dim,ytemp{:});
    catch
        Y=ytemp;
    end
catch
    for idx = 1:numel(fields)
        Y.(fields{idx})=ctlv(X.(fields{idx}),dim);
    end
end
end