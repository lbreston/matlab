function mlsplot(X,Y,ptype)
co = colororder;
linS = {'-'};%{'-','--',':','-.'};

switch ptype
    case 'loglog'
        pltfun=@loglog;
    case 'logx'
        pltfun=@semilogx;
    case 'logy'
        pltfun=@semilogy;
    otherwise
        pltfun=@plot;
end




for i=1:size(Y,2)
    pltfun(X,Y(:,i,1),'linestyle','-','color',co(mod(i,7),:),'linewidth',2); hold on;
end
if size(Y,3)~=1
    for i=1:size(Y,2)
        fill([X.',fliplr(X.')],[Y(:,i,2).',fliplr(Y(:,i,3).')],co(mod(i,7),:),'FaceAlpha', 0.3,'EdgeColor','none'); hold on;
    end
end
end

%linS{mod(i,numel(linS))}