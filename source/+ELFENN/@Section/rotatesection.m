function rotatesection(this, rotation, varargin)
    %ROTATESECTION - Rotate a section
    %
    % Syntax:  rotatesection(rotationAngle, origin)
    %
    % Inputs:
    %    rotation - Euler angles to rotate section (double array)
    %    origin   - Origin about which rotation occurst (double array,optional)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example (rotate section from base):
    %    Assuming you already have a section named exampleSection, if you do
    %    not please see ELFENN.Section.
    %
    %    rotation = [0,0,pi/2]; % 90 degree rotation in z
    %    exampleSection.rotatesection(rotation);
    %
    % Example (rotate section about a point):
    %    Assuming you already have a section named exampleSection, if you do
    %    not please see ELFENN.Section.
    %
    %    rotation = [0,0,pi/2]; % 90 degree rotation in z
    %    origin = [0,0,0]; % rotate about point (0,0,0);
    %    exampleSection.rotatesection(rotation, origin);
    %
    % see also ELFENN.Section
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('rotation', @(x) validateattributes(x(:), ...
        {'numeric'}, {'size', [3, 1], '>', -2 * pi, '<', 2 * pi}));
    
    
    
    p.addOptional('origin', this.startPoint, @(x) validateattributes(x(:), ...
        {'numeric'}, {'size', [3, 1]}));
    
    
    
    p.parse(rotation, varargin{:});
    origin = p.Results.origin;
    
    coordinateList = [this.startPoint; this.endPoint];
    coordinateList = rotateaboutpoint(coordinateList, origin, rotation);
    
    this.startPoint = coordinateList(1, :);
    this.endPoint = coordinateList(2, :);
    
    %------------- END OF CODE --------------
end
