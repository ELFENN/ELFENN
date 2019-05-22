function rotatechunk(this, chunkStart, rotation, varargin)
    %ROTATECHUNK - Rotate branch and all children
    %Rotate a chunk (parent and all children/downstream branches)
    %
    % Inputs:
    %    chunkStart - Name of parent section (String)
    %    rotation   - Euler angles (x,y,z) to rotate (double array)
    %    origin     - Origin (x,y,z) to rotate about (double array, optional)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example (Rotating a chunk):
    %    Assuming you already have a cell named exampleCell, if you do not
    %    please see ELFENN.Cell.
    %
    %    rotation = [0, 0, pi/2]; % 90 deg rotation about the z-axis
    %    exampleCell.rotatecell('dendrite-1',rotation)
    %
    % Example (Rotating a chunk about another point):
    %    Assuming you already have a cell named exampleCell, if you do not
    %    please see ELFENN.Cell.
    %
    %    rotationAngle = [0, 0, pi/2]; % 90 deg rotation about the z-axis
    %    origin = [0,0,100]; % rotate about point (0,0,100);
    %    exampleCell.rotatecell('dendrite-1',rotation, origin)
    %
    % see also ELFENN.Cell ELFENN.Section
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('chunkStart', @(x) any([isstring(x), ischar(x)]));
    p.addRequired('rotation', @(x) validateattributes(x(:), ...
        {'numeric'}, {'size', [3, 1], '>', -2 * pi, '<', 2 * pi}));
    
    
    
    p.addOptional('origin', -1, @(x) validateattributes(x(:), ...
        {'numeric'}, {'size', [3, 1]}));
    
    
    
    p.parse(chunkStart, rotation, varargin{:});
    origin = p.Results.origin;
    
    currentSection = this.getsectionbyname(chunkStart);
    if origin == -1 % if origin is not defined it means that this is the true base of the tree
        currentSection.rotatesection(rotation);
        origin = currentSection.startPoint;
    end
    
    childArray = this.getchildren(chunkStart);
    for child = childArray % recursively apply rotation to children
        childSection = this.getsectionbyname(child);
        childSection.rotatesection(rotation, origin);
        this.rotatechunk(childSection.name, rotation, origin);
    end
    
    %------------- END OF CODE --------------
end