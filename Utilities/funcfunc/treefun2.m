function [Y]=treefun2(FuncIn,X1,X2,params)
if nargin<4
    params={};
end
try
    assert(~isa(X1,'struct'));
    Y=FuncIn(X1,X2);
catch
    fields=fieldnames(X1);
    for idx = 1:numel(fields)
        
        D1=(X1.(fields{idx}));
        D2=(X2.(fields{idx}));
        try
            assert(~isa(D1,'struct'));
            Y.(fields{idx})=FuncIn(D1,D2,params{:});
        catch
            Y.(fields{idx})=treefun2(FuncIn,D1,D2,params);
        end
    end
end

end