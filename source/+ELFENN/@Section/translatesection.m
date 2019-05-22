function translatesection(this, point)
    %TRANSLATESECTION - translate section
    %
    % Inputs:
    %    point - Displacement vector (double array)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a section named exampleSection, if you do
    %    not please see ELFENN.Section.
    %
    %    translation  = [0,0,100]; %translate 100 micron in z
    %    exampleSection.translatesection([0,0,100])
    %
    % see also ELFENN.Section
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('point', @(x) validateattributes(x(:), {'numeric'}, {'size', [3, 1]}));
    p.parse(point);
    
    this.startPoint = this.startPoint + point;
    this.endPoint = this.endPoint + point;
    
    %------------- END OF CODE --------------
end