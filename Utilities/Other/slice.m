function Y = slice(X,S)
Y=cellfun(@(x)squeeze(X{1}(x{:})).',S,'UniformOutput',false);
end
