% treefun applies a function to the leaves of a structure with a tree topology

% inputs
% X: a cell array of M, structs. Each struct must have the topology of a tree with the terminal nodes containing data.
% All of the structs must have the same field names.
% FuncIn: function to be applied to the leaves. Must be an anonymous function with M+numel(params) inputs
% Params: cell array of function parameters

% Ouputs
% Y is a struct with the same fields as those in X.
% Y.(leaf)=FuncIn(X{:}.(leaf),params{:}) where .(leaf) represents the path to a terminal node.


function [Y]=treefun(FuncIn,X,params)
if ~isa(X,'cell')
    X={X};
end
if nargin<3
    params={};
end
try
    assert(~isa(X{1},'struct'));
    Y=FuncIn(X{:},params{:});
catch
    fields=fieldnames(X{1});
    for idx = 1:numel(fields)
        D=cellfun(@(x)x.(fields{idx}),X,'UniformOutput',false);
        try
            assert(~isa(D{1},'struct'));
            Y.(fields{idx})=FuncIn(D{:},params{:});
            
        catch
            Y.(fields{idx})=treefun(FuncIn,D,params);
        end
    end
end

end
