classdef ExtracellularPlates < matlab.mixin.Copyable
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        point
        plane
        
        separation
        stim_function
    end
    
    methods
        function this = ExtracellularPlates(point, plane, sepratation, stim_function) % point as vector, plane as (a,b,c)
            this.point = point;
            this.separation = sepratation; % HOLD UP: ASSUMING CORRECT DISTANCE (inside)
            this.plane = plane;
            this.stim_function = stim_function;
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
