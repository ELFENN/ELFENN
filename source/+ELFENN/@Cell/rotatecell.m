function rotatecell(this, rotation, origin)
    %ROTATECELL - Rotates cell about an optional origin
    %Rotate entire cell about a point
    %
    % Inputs:
    %    rotation - Euler angles (x,y,z) to rotate (double array)
    %    origin   - Origin (x,y,z) to rotate about (double array)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a cell named exampleCell, with a section
    %    named branch5, if you do not please see ELFENN.Cell and
    %    ELFENN.Section.
    %
    %    rotation = [0, 0, pi/2]; % 90 deg rotation about the z-axis
    %    origin = exampleCell.getsectionbyname('branch5').midpoint
    %    exampleCell.rotatecell(rotation, origin)
    %
    % see also ELFENN.Cell ELFENN.Section ELFENN.Section.midpoint
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('rotation', @(x) validateattributes(x(:), {'numeric'}, ...
        {'size', [3, 1], '>', -2 * pi, '<', 2 * pi}));
    
    
    
    p.addRequired('origin', @(x) validateattributes(x(:), {'numeric'}, ...
        {'size', [3, 1]}));
    
    
    
    p.parse(rotation, origin);
    
    for section = this.sections
        section.rotatesection(rotation, origin);
    end
    
    %------------- END OF CODE --------------
end