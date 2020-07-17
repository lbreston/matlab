function [O]=errSafeFetchOutputs(F)
assert(~isa(F,'struct'));
try 
    O=fetchOutputs(F);
catch
    O=[];
end
end