function Y=shuffle(dists,sdim)
y=cat(sdim,dists{:});
ne=cellfun(@(x)numel(x),dists);
sz=cellfun(@(x)size(x),dists);
y=reshape(y,numel(y),1);
y=datasample(y,numel(y));
Y=cell(size(dists));
for i=1:length(dists)
    Y{i}=reshape(y(1:ne(i)),sz(i));
end
end



    



