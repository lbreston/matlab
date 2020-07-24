% movfun applies an abitrary function to a moving window along a choosen dimension of multdimensional arrays. 
% If the function requires multiple variable inputs, each input must have its own array.

% Inputs
% X: a cell array of M, N dimensional, numerical arrays. The arrays must all have the same size
% k: size of moving window
% o: overlap between windows
% Dim: Dimension along which the window is moved
% CatDim: Dimension along which the moving results are concatenated 
% FuncIn: function to be applied to the arrays. Must be an anonymous functions with M inputs 

% Ouputs
% t the array of locations of the centers of the moving windows.  
% Y array of moving function outputs 
% Y(i)=FuncIn(X{1}(i1,i2...i(N)),X{2}(i1,i2...i(N))...X{M}) where i(Dim) = (t(i)-k/2):(t(i)+k/2)

function [Y, t]=movfun(FuncIn,X,k,o,dim,catdim)
if ~isa(X,'cell')
    X={X};
end
if nargin<5
    dim=ndims(X{1});
end
t=gentimepoints(k,o,length(X{1}));
seg=@(x,t)x(t-floor(k/2):min((t+floor(k/2)),length(x)));
ycell=cell(1,length(t));
for i=1:length(t)
    X_seg=cellfun(@(x)dimfun(@(w)seg(w,t(i)),{x},dim),X,'UniformOutput',false);
    ycell{i}=FuncIn(X_seg{:});
end
if nargin<6
    catdim=ndims(ycell{1})+1;
end
Y=cat(catdim,ycell{:});
end

function [p]=gentimepoints(k,overlap,L)
dl=k*(1-overlap);
points=[k/2+1];
while 1
    if (L-points(end))<dl
        break
    else
        points=[points;points(end)+dl];
    end
end
p=floor(points);
end





