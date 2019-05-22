classdef Section < matlab.mixin.Copyable
    %SECTION - ELFENN.Section class
    %
    % Syntax:  Cell(name, 'sectionGeometry', g, 'radius', r, 'sectionLength', l, 'nSeg', n, 'nAxes', a, 'Ra', Ra, 'isNEURON', q)
    %
    % Inputs:
    %    name - Cell name (String)
    %    g    - Section geometry ('S', or 'C') (String)
    %    r    - Radius (double)
    %    l    - Length (double)
    %    n    - Number of segments (integer)
    %    a    - Number of axes for recorders (integer)
    %    Ra   - Axial resistance (double)
    %    q    - Flag for neuron area scaling; spheres are scaled by a factor of 2 in NEURON/LFP (logical)
    %
    % Outputs:
    %    None
    %
    % Example (default section):
    %    This creates a cylindrical section 100um long with a radius of 1
    %    micron.
    %    exampleSection = ELFENN.Section('section');
    %
    % Example (spherical section):
    %    Note for a spherical section the length must be 2x the radius
    %    exampleSection = ELFENN.Section('soma', 'radius', 25, 'sectionLength', 50, 'sectionGeometry', 'S');
    %
    % Example (specify axial resistance)
    %    exampleSection = ELFENN.Section('section' 'Ra', 50);
    %
    % Raises:
    %    Warning - Segment size too small
    %    Warning - Invalid number of spherical segments
    %    Error   - Sphere radius does not match length
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    properties
        dynamicsParameters; % Struct of parameters for ODE
        endPoint % Coordinates of end of section
        name % Section name
        Ra % Axial resistance
        radius % Radius of section
        sectionGeometry % Sphere (S) or cylinder (C)
        sectionLength % Length of the section
        segments % List of segments in section
        startPoint % Coordinates of start of section
    end
    
    properties(Hidden)
        connectivity; % Connectivity of the segments
        isNEURON; % Flag for neuron area
        nAxes; % Number of axes to create recorders for
        nSeg % Number of segments section will be divided into
        somaAngle % If section is added to a sphere: the angle it make with it
    end
    
    properties(Dependent)
        isCylinder; % Is the section cylindrical
        segmentArea; % Area of each segment
        segmentLength; % Length of each segment
        mid; % Index of middle section (median section)
        midpoint; % Coordinates of midpoint of section
        tip; % Index of tip of section (section 1)
    end
    
    methods
        function this = Section(name, varargin)
            p = inputParser;
            p.addRequired('name', @(x) any([isstring(x), ischar(x)]));
            p.addParameter('sectionGeometry', 'C', @(x) any(strcmp(x, {'S', 'C'})));
            p.addParameter('radius', 1, @(x) validateattributes(x, {'numeric'}, {'positive'}));
            p.addParameter('sectionLength', 100, @(x) validateattributes(x, {'numeric'}, {}));
            p.addParameter('nSeg', 5, @(x) validateattributes(x, {'numeric'}, {'odd', 'positive'}));
            p.addParameter('nAxes', 2, @(x) validateattributes(x, {'numeric'}, {'positive'}));
            p.addParameter('Ra', 35.4, @(x) validateattributes(x, {'numeric'}, {'positive'}));
            p.addParameter('isNEURON', false, @(x) validateattributes(x, {'logical'}, {}));
            p.addParameter('starting', false, @(x) validateattributes(x, {'numeric'}, {}));
            p.addParameter('ending', false, @(x) validateattributes(x, {'numeric'}, {}));
            
            p.parse(name, varargin{:})
            
            this.name = string(name);
            this.radius = p.Results.radius;
            this.sectionLength = p.Results.sectionLength;
            
            this.sectionGeometry = p.Results.sectionGeometry;
            this.nSeg = p.Results.nSeg;
            
            if this.segmentLength < 2
                warning('Section < 2um : system can be numerically unstable')
            end
            if ~this.isCylinder
                if this.nSeg ~= 1
                    this.nSeg = 1;
                    warning('Invalid nseg specified for spherical section');
                end
            end
            this.nAxes = p.Results.nAxes;
            this.Ra = p.Results.Ra;
            
            if this.isCylinder
                if this.sectionLength ~= -1 % TODO HACK
                    this.startPoint = [0, 0, 0];
                    this.endPoint = [this.sectionLength, 0, 0];
                else
                    this.startPoint = p.Results.starting;
                    this.endPoint = p.Results.ending;
                    this.sectionLength = sqrt(sum((p.Results.starting - p.Results.ending).^2));
                end
            else
                this.startPoint = [-this.radius, 0, 0];
                this.endPoint = [this.radius, 0, 0];
            end
            if (~this.isCylinder) && (abs((2 * this.radius - this.sectionLength)) > eps)
                error('Sphere radius does not match length');
            end
            
            this.isNEURON = p.Results.isNEURON;
        end
        
        function isCylinder = get.isCylinder(this)
            isCylinder = strcmp(this.sectionGeometry, 'C');
        end
        
        function mid = get.mid(this)
            mid = this.segments(median(1:length(this.segments))).connectivityid;
        end
        
        function midpoint = get.midpoint(this)
            midpoint = (this.startPoint + this.endPoint) / 2;
        end
        
        function segmentArea = get.segmentArea(this)
            if this.isCylinder
                segmentArea = 2 * pi * this.radius * this.segmentLength;
            else
                if this.isNEURON
                    segmentArea = 2 * pi * this.radius * this.segmentLength;
                else
                    segmentArea = 4 * pi * this.radius^2;
                end
            end
        end
        
        function segmentLength = get.segmentLength(this)
            segmentLength = this.sectionLength / this.nSeg;
        end
        
        function tip = get.tip(this)
            tip = this.segments(1).connectivityid;
        end
    end
    
    methods(Hidden)
        appendsegment(this, segment)
        connectsegment(this, segment1, segment2)
        discretize(this)
        rotatesection(this, t, origin)
        translatesection(this, p)
        
        segment = getsegmentbyname(this, name)
    end
    
    %------------- END OF CODE --------------
end