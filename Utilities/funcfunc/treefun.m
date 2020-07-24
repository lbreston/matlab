% treefun applies an arbitrary function to the leaves of a struct with a tree topology. 
% If the function requires multiple variable inputs, each input must have its own structure.
 
% Inputs
% X: a cell array of M, structs. Each struct must have the topology of a tree with the terminal fields containing data.
% All of the structs must have the same field names.
% FuncIn: function to be applied to the leaves. Must be an anonymous function with M+numel(params) inputs
% Params: cell array of fixed function parameters
 
% Outputs
% Y is a struct with the same fieldnames as those in X.
% Y.(leaf)=FuncIn(X{:}.(leaf),params{:}) where .(leaf) represents the path to a terminal field.


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
