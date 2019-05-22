function segment = getsegmentbyname(this, name)
    %GETSEGMENTBYNAME - Get a handle to a segment given its name
    %Since all segments are named node* this function will be deprecated and
    %possibly removed in future releases
    %
    % Inputs:
    %    name - Segment name (String)
    %
    % Outputs:
    %    segment - Handle to segment (ELFENN.Segment)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a section named exampleSection, if you do
    %    not please see ELFENN.Section.
    %
    %    exampleSection.getsegmentbyname('node1')
    %
    % see also ELFENN.Section
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('name', @(x) validateattributes(x, {'string', 'char'}, {}));
    p.parse(name);
    
    segment = this.segments([this.segments.name] == name);
    
    %------------- END OF CODE --------------
end