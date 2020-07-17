function [Y]=partreefun(FuncIn,X,extract)
if nargin<3
    extract=true;
end
yf=partreefunFuture(FuncIn,X);
f=catleaves(yf,1,true);
YFuture = afterAll(f, @(~)treefun(@(x)errSafeFetchOutputs(x),yf), 1,'PassFuture',true);
if extract
    Y=fetchOutputs(YFuture);
else
    Y=YFuture;
end
end
function [yf]=partreefunFuture(FuncIn,X,loc)

if nargin<3
    loc={};
end

try
    assert(~isa(X,'struct'));
    if nargin(FuncIn)==1
        yf=parfeval(FuncIn,1,X);
    else
        yf=parfeval(FuncIn,1,X,loc);
    end
catch
    fields=fieldnames(X);
    for idx = 1:numel(fields)
        D=(X.(fields{idx}));
        loc=[loc,fields(idx)];
        loc=loc(~cellfun('isempty',loc));
        try
            assert(~isa(D,'struct'));
            if nargin(FuncIn)==1
                yf.(fields{idx})=parfeval(FuncIn,1,D);
            else
                yf.(fields{idx})=parfeval(FuncIn,1,D,loc);
            end
            loc={};
        catch
            yf.(fields{idx})=partreefunFuture(FuncIn,D,loc);
        end
    end
end

end
