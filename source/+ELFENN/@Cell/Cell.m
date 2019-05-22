classdef Cell < matlab.mixin.Copyable
    %CELL - ELFENN.Cell class
    %
    % Inputs:
    %    name - Cell name (String)
    %
    % Outputs:
    %    None
    %
    % Example (creating cell):
    %    exampleCell = ELFENN.Cell('cell');
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    properties
        name % Cell name assigned in constructor
        sections % Array of sections added to cell
    end
    
    properties(Hidden)
        connectivity % Connectivity between sections
        isDiscretized % Has the cell been discretized into segments
        nSections % Number of sections in cell
        resistivefdm % Effective finit difference array for cell cable equation
        segmentConnectivityW % Nx2 array of unique segment names and their mating pair
        segmentconnectivityIX % Nx2 array of unique segment id's and their mating pair
    end
    
    properties(Dependent)
        soma % First segment of section named soma
        sectionNames % List of section names
        nTotalSeg % Total of segments in cell
        tip % First segment - good for cables
    end
    
    methods
        function this = Cell(name)
            p = inputParser;
            p.addRequired('name', @(x) validateattributes(x, {'string', 'char'}, {}));
            this.name = name;
        end
        
        function nSections = get.nSections(this)
            nSections = length(this.sections);
        end
        
        function nTotalSeg = get.nTotalSeg(this)
            nTotalSeg = sum([this.sections.nSeg]);
        end
        
        
        function sectionNames = get.sectionNames(this)
            sectionNames = [this.sections.name];
        end
        
        function soma = get.soma(this)
            try
                soma = this.getsectionbyname('soma').segments(1).connectivityid;
            catch
                error('No Section Named Soma');
            end
        end
        
        function tip = get.tip(this)
            tip = this.sections(1).segments(1).connectivityid;
        end
        
        appendsection(this, child)
        connectsection(this, parent, varargin)
        rotatecell(this, rotation, origin)
        rotatechunk(this, chunkStart, rotation, varargin)
        rotateoffsoma(this, name)
        translatecell(this, offset)
        
        newCellBaseIndex = complete(this, cellBaseIndex)
        children = getchildren(this, name)
        section = getsectionbyname(this, name)
    end
    
    methods(Hidden)
        assignsolutionindex(this, names)
        calculatefinitedifference(this, cellbaseindex)
        discretize(this)
        labelconnectivityid(this, cellBaseIndex)
        
        cellBaseIndex = calculatefullconnectivity(this, cellBaseIndex)
    end
    
    methods(Access = protected)
        function clone = copyElement(this)
            clone = copyElement@matlab.mixin.Copyable(this);
            clone.sections = copy(clone.sections);
        end
    end
    
    %------------- END OF CODE --------------
end
