classdef Electrode < matlab.mixin.Copyable
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stim_function
        position
    end
    
    methods
        function this = Electrode(position, stim_function)
            this.stim_function = stim_function;
            this.position = position;
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
