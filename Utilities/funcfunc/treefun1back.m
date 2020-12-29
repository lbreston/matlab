function out=treefun1back(fcn,X)
fields=fieldnames(X);
stest=cellfun(@(x)~isa(X.(x),'struct'),fields);
try
    assert(any(stest));
    out=fcn(X);
catch
    for idx = 1:numel(fields)
        out.(fields{idx})=treefun1back(fcn,X.(fields{idx}));
    end
end
end