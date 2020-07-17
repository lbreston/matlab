classdef pipe < dynamicprops 
    properties
    end
    methods
        function obj = pipe(varargin)
            
            if nargin==1
                if isa(varargin{1},'pipe')
                    obj = varargin{1};
                elseif isa(varargin{1},'struct')
                    obj = struct2pipe(obj,varargin{1});
                end
            end
            
            function obj = struct2pipe(obj,S)
                fn=fieldnames(S);
                for i=1:length(fn)
                    s=string(fn{i});
                    if (isa(S.(s),'function_handle')&&( ~contains(s,'fcn')))
                        fs=strcat(s,'_fcn');
                        obj.addprop(fs);
                        obj.(fs)=S.(s);
                        obj.addprop(s);
                        obj.(s)=[];
                        prop = findprop(obj,s);
                        prop.GetMethod = pipe.getMethodMethod(s,fs);
                    else
                        obj.addprop(s);
                        obj.(s)=S.(s);
                    end
                end
            end
        end
        
        function obj = setvals(obj,val,varargin)
            p=properties(obj);
            
            if strcmp(varargin{1},'all')
                for i=1:length(p)
                    if ~isa(obj.(p{i}),'function_handle')
                        obj.(p{i})=val;
                    end
                end
            elseif strcmp(varargin{1},'allbut')
                for i=1:length(p)
                    cl=cellfun(@(x)strcmp(string(p{i}),x),varargin{2:end});
                    if ~isempty(cl)
                        if ~isa(obj.(p{i}),'function_handle')
                            obj.(p{i})=val;
                        end
                    end
                end
            else
                for i=1:length(varargin)
                    obj.(varargin{i})=val;
                end
            end
        end
        
        function obj = join(obj1,obj2)
            s1=struct(obj1);
            s2=struct(obj2);
            fn=[fieldnames(s1);fieldnames(s2)];
            fn=cellfun(@(x)erase(x,'_fcn'),fn,'UniformOutput',false');
            fv=[struct2cell(s1);struct2cell(s2)];
            [~,fni,~]=unique(fn,'last');
            s3=cell2struct(fv(fni),fn(fni),1);
            obj = pipe(s3);
           end
           
        function obj = lt(obj1,obj2)
            obj=join(obj1,obj2);
        end
   
    end
    
    methods (Static, Hidden) 
        
        function fcn = getMethodMethod(s,fs)
            fcn = @getMethod;
            
         function val = getMethod(obj)
            if isempty(obj.(s))      
                val = obj.(fs)(obj); 
                obj.(s)=val; 
            else
              val = obj.(s);
            end
         end
        end
        
        function val = initval(s)
            if 1
                error(s);
            end
            val=[];
        end     
    end
    
    
    
end
          
    
       

        
       
  
        