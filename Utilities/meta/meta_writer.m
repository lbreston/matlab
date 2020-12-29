function meta_writer(template_path,out_path,varargin)

fid = fopen(template_path);
text = textscan(fid,'%s','delimiter','\n');
fclose(fid);

s=cell(length(text{:})*2,1);
s(1:2:end-1)=text{:};
s(2:2:end)={"\n"};
s=strcat(s{:});

fs=compose(s,varargin{:});

fid = fopen(out_path,'w');
fprintf(fid,'%s\n',fs);
fclose(fid);

end

