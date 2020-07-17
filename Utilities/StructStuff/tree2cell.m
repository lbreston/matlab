function [Y]=tree2cell(X)
fields=fieldnames(X);
if isstruct(X.(fields{1}))
    Y= struct2cell(structfun(@(x)tree2cell(x),X,'UniformOutput',false));
else
    Y = struct2cell(X);
end
end