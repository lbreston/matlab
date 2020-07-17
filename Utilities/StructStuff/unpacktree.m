function [varargout]=unpacktree(X,depth)

persistent dvals maxdepth

fields=fieldnames(X);

if isempty(dvals)
    dvals={fields};
    maxdepth=1;
    depth = 1;
end

if isempty(find(cellfun(@(f)isequal(f,fields),dvals)))
    dvals{1,end+1} = fields;
end

if isstruct(X.(fields{1}))
    depth=depth+1;
    ytemp= struct2cell(structfun(@(x)unpacktree(x,depth),X,'UniformOutput',false));
else
    ytemp = struct2cell(X);
end
try
    nd=ndims(ytemp{1});
    Y = cat(nd+1,ytemp{:});
    if depth>maxdepth
        maxdepth=depth;
    end
    depth=1;  
catch
    Y = ytemp;
end

if isa(Y,'cell')
     error('tree cannot be unpacked');
end

if numel(dvals)>maxdepth
    error('tree has inconsistent depth');
end
varargout{1}=Y;
if nargout == 2 
    dvs=cell(1,ndims(Y));
    dvs([length(dvs):-1:length(dvs)-length(dvals)+1])=dvals;
    varargout{2}=dvs;
end
clear dvals;
clear maxdepth;
end