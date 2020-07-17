function [Y]=treefun(FuncIn,X,loc)
if nargin<3
    loc={};
end

try
    assert(~isa(X,'struct'));
    if nargin(FuncIn)==1
            Y=FuncIn(X);
        else
            Y=FuncIn(X,loc);
    end
catch
fields=fieldnames(X);
for idx = 1:numel(fields)
    D=(X.(fields{idx}));
    loc=[loc,fields(idx)];
    loc=loc(~cellfun('isempty',loc));
    try
        if nargin(FuncIn)==1
            Y.(fields{idx})=FuncIn(D);
        else
            Y.(fields{idx})=FuncIn(D,loc);
        end
        loc={};
    catch
        Y.(fields{idx})=treefun(FuncIn,D,loc);
    end
end
end

end
