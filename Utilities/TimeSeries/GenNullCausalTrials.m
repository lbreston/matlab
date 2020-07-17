function [NullTrials]=GenNullCausalTrials(data,n)

fields=fieldnames(data);
for idx = 1:numel(fields)
    if ~isa(data.(fields{1}),'struct')
        [Df,avgL]=FlattenSructData(data);
        for i=1:n
        NullTrials.('t'+string(i))=GenRandTrial(Df,avgL);
        end
    else
        D=(data.(fields{idx}));
        NullTrials.(fields{idx})=GenNullCausalTrials(D,n);
    end
end
end