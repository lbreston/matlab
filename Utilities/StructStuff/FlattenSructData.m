function [D,avgL]=FlattenSructData(data)
D=[];
fields=fieldnames(data);
for i=1:numel(fields)
    D=[D,data.(fields{i})];
end
avgL=floor(length(D)/numel(fields));
end
