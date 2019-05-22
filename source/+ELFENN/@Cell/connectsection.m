function connectsection(this, parent, varargin)
    %CONNECTSECTION - Connect a new section onto a cell
    %
    % Inputs:
    %    parent    - Parent branch to append to (ELFENN.Section)
    %    child     - New branch to append (ELFENN.Section, Optional)
    %    somaAngle - Euler angles (x,y,z) between branch and soma if parent is soma (double array, Optional)
    %    forced    - Flag if child segment points are to be forced - used in geometry parsing (should not be used by end user) (logical: 0/1)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    Warning - parent is added without a child (single section)
    %    Warning - if parent is soma and no soma angle is specified
    %
    % Example(adding single section):
    %    Assuming you already have a cell named exampleCell, and a section
    %    named section1, if you do not please see ELFENN.Cell, and
    %    ELFENN.Section
    %
    %    exampleCell.appendsection(section1);
    %
    % Example (adding multiple sections):
    %    Assuming you already have a cell named exampleCell, and 2 segments
    %    named section1, and section2 if you do not please see ELFENN.Cell, and
    %    ELFENN.Section
    %
    %    If section1 has already been added, you must specify it as the parent
    %
    %    exampleCell.appendsection(section1, section2);
    %
    %    If exampleCell is empty you may either specify section1 as a single
    %    segment and then add section2 (this is not recommended but valid)
    %
    %    exampleCell.appendsection(section1);
    %    exampleCell.appendsection(section1, section2);
    %
    %    or they can be added together (recommended)
    %
    %    exampleCell.appendSection(section1, section2);
    %
    % see also ELFENN.Cell ELFENN.Section
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('parent', @(x) validateattributes(x, ...
        {'ELFENN.Section'}, {}));
    
    
    
    p.addOptional('child', -1, @(x) validateattributes(x, ...
        {'ELFENN.Section'}, {}));
    
    
    
    p.addOptional('somaAngle', [0, 0, 0], @(x) validateattributes(x(:), ...
        {'numeric'}, {'size', [3, 1], '>', -2 * pi, '<', 2 * pi}));
    
    
    
    p.addParameter('forced', 0);
    p.parse(parent, varargin{:});
    
    somaAngle = p.Results.somaAngle;
    child = p.Results.child;
    forced = p.Results.forced;
    
    parent = parent.copy();
    
    if this.nSections == 0 % if this is the first parent (generally a soma)
        this.sections = parent;
    end
    
    if child == -1
        warning('Cell will be a single section');
    else
        parent = this.getsectionbyname(parent.name); % get cell copy of parent
        child = child.copy();
        
        if parent.isCylinder % forced will not be used for cylindrical parents
            child.translatesection(parent.endPoint);
        else
            if ~forced % if forsed assume points are properly specified
                if any(strcmp(p.UsingDefaults, 'angleOnSoma'))
                    warning('No soma angle specified: added section will extend in positive x direction');
                end
                radiusvector = [parent.radius, 0, 0];
                somapoint = rotateaboutpoint(radiusvector, [0, 0, 0], somaAngle);
                child.translatesection(somapoint)
                child.somaAngle = somaAngle; % child is not parallel to radial axis this is saved for later
            end
        end
        
        this.appendsection(child);
        
        % Build up a connectivity matrix along the section. Not strictly
        % necissary as it (should) always look tri-diag with the true diagonal
        % being zero
        
        newparentidx = find([this.sections.name] == parent.name);
        newchildidx = find([this.sections.name] == child.name);
        
        this.connectivity(newparentidx, newchildidx) = 1;
        this.connectivity(newchildidx, newparentidx) = 0;
    end
    
    %------------- END OF CODE --------------
end