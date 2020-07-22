% The pipe class uses dynamically defined properties to efficiently create and manage analysis pipelines. 

% A pipe consists of properties, their values, and the functions used to compute them
% A pipe's visible properties are dependent, meaning they can not store data and are calculated on demand 
% The functions for computing the visibile properties are stored in the hidden "functions" property which has the form functions.property = @(obj)Func(obj)
% The values of the visibile properties are stored in the hidden "values" property which has the form values.property = val

% When a visible property is set, the assigned value is stored in values.property 
% When a visible property is called, the pipe will either return the stored value, or, if its empty, return functions.property(obj) and store the computed value
% This design allows for variables within a pipeline to be addressed on demand, while avoiding redundant calculations.

% To recompute values, they must first be cleared. This can done by setting them to [] or using obj.clear()

% A pipe is created from a struct, S, of function handles
% S has the form S.PropertyName = @(obj)Function(). The functions must have "obj" as their only input
% To define properties which require external input use the function @(obj)pipe.initval('Requires Input');
% To define functions which reference other properties within the pipe use the form @(obj)Function(obj.Prop1,obj.Prop2...)
% pipe(S) constructs a pipe with visible properties of the field names of S, and builds their corresponding get and set methods. 

% Saving a pipe only saves the pipe definition and not the property values.

% The syntax Input|pipe and pipe|Output can be used to interface with pipes.  
% Inputs must either be a struct with the format S.PropertyName = Val  or a cell array with the format {'PropertyName',val,'PropertyName',val}
% Input|pipe returns a pipe with properties set to the Input values
% Outputs must either be a struct with the format S.field = 'PropertyName'  or a cell array with the format {'fieldname','PropertyName','fieldname','PropertyName'}
% pipe|Output returns a struct with the format S.field = pipe.PropertyName.
% These commands are evaluated from left to right which allows pipes to be daisy chained together. i.e. I|pipe1|O|pipe2... 

% The syntax pipe3=pipe1>pipe2 or pipe3=join(pipe1,pipe2) can be used to combine pipes. pipe3 contains all the properties of both pipes. 
% If pipe1 and pipe2 have a property with the same name the definition from pipe1 is used. 



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
        
        
        function obj = clear(obj,varargin)
            %clear(obj,prop1,prop2...) sets props to [];
            %clear(obj,'allbut',prop1,prop2...) sets all props except those listed to [];
            %clear(obj,'all') sets all props to [];
            val=[];
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
          
    
       

        
       
  
        