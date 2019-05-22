function section = getsectionbyname(this, name)
    %GETSECTIONBYNAME - Get section given its name
    %Get a reference to a section by name
    %
    % Inputs:
    %    name - Name of section to get (String)
    %
    % Outputs:
    %    section - Reference to section (ELFENN.Section)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a cell named exampleCell, if you do not
    %    please see ELFENN.Cell.
    %
    %    Suppose example cell has a section named "branch5", then the handle to
    %    branch5 is
    %
    %    section = exampleCell.getsectionbyname("branch5")
    %
    %    Warning: if using an older version of matlab where double-quoted
    %    strings are not supported. The following syntax is required
    %
    %    section = exampleCell.getsectionbyname(string('branch5')); or
    %    section = exampleCell.getsectionbyname('branch5');
    %
    % see also ELFENN.Cell, ELFENN.Section
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('name', @(x) validateattributes(x, {'string', 'char'}, {}));
    p.parse(name);
    
    section = this.sections([this.sections.name] == name);
    
    %------------- END OF CODE --------------
end