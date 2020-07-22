function [Y]=treefun(FuncIn,X,params)

if nargin<3
    params={};
end
try
    assert(~isa(X,'struct'));
    Y=FuncIn(X,params{:});
catch
    fields=fieldnames(X);
    for idx = 1:numel(fields)
        D=(X.(fields{idx}));
        try
            assert(~isa(D,'struct'));
            Y.(fields{idx})=FuncIn(D,params{:});
            
        catch
            Y.(fields{idx})=treefun(FuncIn,D,params);
        end
    end
end

end
