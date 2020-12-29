function out=getleaves(S,varargin)
ss=substruct(varargin{:});
out=treefun(@(x)subsref(x,ss),S);
end