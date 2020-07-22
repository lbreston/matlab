function [Y]=partreefun(FuncIn,X,params,create,extract)
if nargin<5
    extract=true;
end
if nargin<4
    extract=true;
    create=true;
end
if nargin<3
    params={};
    extract=true;
    create=true;
end


p = gcp('nocreate');
if (~create&&isempty(p))
    Y=treefun(FuncIn,X,params);
    return
end

yf=partreefunFuture(FuncIn,X,params);
f=catleaves(yf,1,true);
YFuture = afterAll(f, @(~)treefun(@(x)errSafeFetchOutputs(x),yf), 1,'PassFuture',true);
if extract
    Y=fetchOutputs(YFuture);
else
    Y=YFuture;
end
end
function [yf]=partreefunFuture(FuncIn,X,params,loc)

if nargin<4
    loc={};
end

try
    assert(~isa(X,'struct'));
    yf=parfeval(FuncIn,1,X,params{:});
catch
    fields=fieldnames(X);
    for idx = 1:numel(fields)
        D=(X.(fields{idx}));
        loc=[loc,fields(idx)];
        loc=loc(~cellfun('isempty',loc));
        try
            assert(~isa(D,'struct'));
            yf.(fields{idx})=parfeval(FuncIn,1,D,params{:});
            loc={};
        catch
            yf.(fields{idx})=partreefunFuture(FuncIn,D,params,loc);
        end
    end
end

end
