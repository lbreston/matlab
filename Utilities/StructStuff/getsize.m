function s = getsize(d,l)
f=getfield(d,l{:});
assert(~isa(f,'struct'))
try 
   s= size(f,ndims(f)) ;
catch
end
end