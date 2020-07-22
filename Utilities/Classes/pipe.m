classdef pipe < dynamicprops 

    properties  (Hidden)
        functions
        values
    end
    
    
    properties
    
    end
    
    methods
        function obj = pipe(P)
            
            if nargin==1
                obj.functions=P;
                obj = struct2pipe(obj,P);
            end
           
            function obj = struct2pipe(obj,S)
                fn=fieldnames(S);
                for i=1:length(fn)
                    s=string(fn{i});
                    
                    obj.values.(s)=[];
                    obj.addprop(s);
                    
                    prop = findprop(obj,s);
                    prop.Dependent = true;
                    prop.GetMethod = pipe.getMethodMethod(s);
                    prop.SetMethod = pipe.setMethodMethod(s);
                end
            end
                
           
        end
        
        function obj = setvals(obj,val,varargin)
            p=properties(obj);
            p(strcmp(p,'functions'))=[];
            if strcmp(varargin{1},'all')
                for i=1:length(p)
                    obj.(p{i})=val;
                end
            elseif strcmp(varargin{1},'allbut')
                for i=1:length(p)
                    cl=cellfun(@(x)strcmp(string(p{i}),x),varargin{2:end});
                    if ~isempty(cl)
                        obj.(p{i})=val;
                    end
                end
            else
                for i=1:length(varargin)
                    obj.(varargin{i})=val;
                end
            end
        end
        
        function obj = join(obj1,obj2)
            s1=obj1.functions;
            s2=obj2.functions;
            fn=[fieldnames(s1);fieldnames(s2)];
            fv=[struct2cell(s1);struct2cell(s2)];
            [~,fni,~]=unique(fn,'first');
            s3=cell2struct(fv(fni),fn(fni),1);
            obj = pipe(s3);
           end
           
        function obj = gt(obj1,obj2)
            obj=join(obj1,obj2);
        end
        
        function C = or(A,B)
            if isa(A,'cell')
                A=struct(A{:});
            end
            if isa(B,'cell')
                B=struct(B{:});
            end
            if isa(B,'pipe')
                if isa(A,'struct')
                    fn=fieldnames(A);
                    for i=1:length(fn)
                        s=string(fn{i});
                        B.(s)=A.(s);
                    end
                    C=B;
                end
            end
            if isa(B,'struct')
                if isa(A,'pipe')
                    
                    fn=fieldnames(B);
                    for i=1:length(fn)
                        try
                            s=string(fn{i});
                            B.(s)=A.(B.(s));
                        catch
                        end
                    end
                end
                C=B;
            end
        end
        

        
        function s = saveobj(obj)
            s=obj.functions;
        end
    end
    
    methods (Static, Hidden) 
        
        function fcn = getMethodMethod(s)
            fcn = @getMethod;
            
         function val = getMethod(obj)
            if isempty(obj.values.(s))      
                val = obj.functions.(s)(obj); 
                obj.values.(s)=val; 
            else
              val = obj.values.(s);
            end
         end
        end
        
        function fcn = setMethodMethod(s)
            
            fcn = @setMethod;
            
            function obj = setMethod(obj,val)
                obj.values.(s)=val;
            end
        end
        
        function val = initval(s)
            if 1
                error(s);
            end
            val=[];
        end
        
        function obj = loadobj(s)
            obj=pipe(s);
        end
  
    end
    
    
    
end
          
    
       

        
       
  
        