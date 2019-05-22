classdef Segment < handle
    %SEGMENT - ELFENN.Segment class
    % Segments should only ever be used internally, if you are reading this
    % documentation you likely made a mistake.
    %
    % Inputs:
    %    name - Segment name of form 'node1' (2,3, ...) (String)
    %    p    - Segment position (numeric array)
    %    r    - Segment recorders (numeric array)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    exampleSegment = ELFENN.Segment('node1', [0,0,0], recorders);
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    properties
        position; % position of segment
        name; % Name of segment: starts with "node"
        recorders; % list of recorders attached to segment
        connectivityid = -1; % effective ID
        ODEID = {}; % list of ODE variable indeces
    end
    
    methods
        function this = Segment(name, position, recorders)
            p = inputParser;
            p.addRequired('name', @(x) any([isstring(x), ischar(x)]));
            p.addRequired('position', @(x) validateattributes(x(:), {'numeric'}, {'size', [3, 1]}));
            p.addRequired('recorders', @(x) validateattributes(x, {'numeric'}, {'ncols', 3, '2d'}));
            
            p.parse(name, position, recorders);
            this.recorders = recorders;
            this.position = position;
            this.name = name;
        end
    end
    
    methods(Static)
        recorders = calculaterecorders(r, nAxes, style, y)
    end
    
    %------------- END OF CODE --------------
end
