% partreefun is a parallel version of treefun which evaluates FuncIn on all of the leaves in parallel 
% Since trees are acyclic the operations are guaranteed to be independent and any treefun can be parallelized. 

% inputs 
% create: If create is true partreefun will create a parallel pool, if one does not already exist, and execute in parallel. 
% If create is false partreefun will only execute in parallel if a pool already exists and otherwise calls treefun. 
% The default value of create is true. 
% extract: ture or false. Default is true 

% Outputs
% If extract is true Y is returned as a struct. 
% If extract is false, Y is left as an afterAll object. To obtain the struct use the function fetchOutputs(Y) This allows partreefun to run in the background. 



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

function [yf]=partreefunFuture(FuncIn,X,params)
if ~isa(X,'cell')
    X={X};
end
if nargin<3
    params={};
end
try
    assert(~isa(X{1},'struct'));
    yf=parfeval(FuncIn,1,X{:},params{:});
catch
    fields=fieldnames(X{1});
    for idx = 1:numel(fields)
        D=cellfun(@(x)x.(fields{idx}),X,'UniformOutput',false);
        try
            assert(~isa(D{1},'struct'));
            yf.(fields{idx})=parfeval(FuncIn,1,D{:},params{:});
        catch
            yf.(fields{idx})=partreefunFuture(FuncIn,D,params,loc);
        end
    end
end

end

function [O]=errSafeFetchOutputs(F)
assert(~isa(F,'struct'));
try 
    O=fetchOutputs(F);
catch
    O=[];
end
end