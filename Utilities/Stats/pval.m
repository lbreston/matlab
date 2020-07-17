function p=pval(dist,condition)
p=numel(find(condition(dist)))/numel(dist);
end