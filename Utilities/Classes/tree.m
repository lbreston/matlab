% The tree class creates objects which implement treefun through subscripted indicies 
% Trees can have any value that is compatible with treefun
% obj.(func).(params)=tree(treefun(func,obj.vals,params))
classdef tree
    properties
        val
    end
    methods
        function obj = tree (val)
            if nargin==1
                obj.val = val;
            end
        end
        
        function varargout = subsref (self, S)
            try
                [varargout{1:nargout}] = builtin('subsref', self, S);
            catch
                
                if size(S,2)==1
                    params={};
                else
                    params=S(2).subs;
                end
                [varargout{1:nargout}] = tree(partreefun(S(1).subs,self.val,params,false));
            end
        end
        
        function obj = horzcat(varargin)
            obj = tree(cellfun(@(x)x.val,varargin,'UniformOutput',false));
        end
        
        function obj = catleaves(obj,dim,r)
            if nargin < 3
                r=false;
            end
            if nargin<2
                dim=[];
            end
            if isa(obj.val,'cell')
                obj.val=cellfun(@(x)catleaves(x,dim,r),obj.val);
            elseif isa(obj.val,'struct')
                obj.val = catleaves(obj.val,dim,r);
            end
        end
    end
        
end