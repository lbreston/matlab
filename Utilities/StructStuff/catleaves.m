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
try
    assert(~isa(X.(fields{1}),'struct'));
    ytemp = struct2cell(X);
    if isempty(dim)
        dim=ndims(ytemp{1})+1;
    end
    Y = cat(dim,ytemp{:});
catch
    for idx = 1:numel(fields)
        Y.(fields{idx})=ctlv(X.(fields{idx}),dim);
    end
end
end