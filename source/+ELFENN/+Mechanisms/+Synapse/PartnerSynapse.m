classdef PartnerSynapse < matlab.mixin.Copyable
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parameters
        f
        position
        presyn
    end
    
    methods
        function this = PartnerSynapse(position, parameters, f, presyn)
            this.position = position;
            this.parameters = parameters;
            this.f = f;
            this.presyn = presyn;
        end
        function current = current_function(this, t, v)
            current = -this.parameters.gSyn .* this.f(t, this.parameters) .* (v - this.parameters.ESyn);
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
