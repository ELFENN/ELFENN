classdef PointSynapse < matlab.mixin.Copyable
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        current_function
        position
        eventtimes
    end
    
    methods
        function this = PointSynapse(position, current_function, t0)
            this.current_function = current_function;
            this.position = position;
            this.eventtimes = t0;
        end
    end
    
    methods(Access = protected)
        % Override copyElement method:
        function clone = copyElement(this)
            clone = copyElement@matlab.mixin.Copyable(this);
            clone.sections = copy(clone.sections);
        end
    end
end
