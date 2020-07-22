function Y = slice(X,dim)
nd=ndims(X);
dlist=1:nd;
sdims=setdiff(dlist,dim);
Y=num2cell(X,sdims);
end
