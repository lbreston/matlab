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


