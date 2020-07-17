function [Y]=treefun2(FuncIn,X1,X2,loc)
if nargin<4
    loc={};
end
try
     assert(~isa(X1,'struct'));
     Y=FuncIn(X1,X2);
catch
fields=fieldnames(X1);
for idx = 1:numel(fields)
    loc=[loc,fields(idx)];
    loc=loc(~cellfun('isempty',loc));
    
    D1=(X1.(fields{idx}));
    D2=(X2.(fields{idx}));
    try
        Y.(fields{idx})=FuncIn(D1,D2);
        loc={};
    catch
        Y.(fields{idx})=treefun(FuncIn,D1,D2,loc);
    end
end
end

end