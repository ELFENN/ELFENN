function children = getchildren(this, name)
    %GETCHILDREN - Get children of section by name
    %Get all children (downstream sections) of a cell given the name of the
    %parent
    %
    % Inputs:
    %    name     - Name of parent section (String)
    %
    % Outputs:
    %    children - List of references to child sections (ELFENN.Section array)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a cell named exampleCell, if you do not
    %    please see ELFENN.Cell.
    %
    %    Suppose example cell has a section named "branch5", then the handle to
    %    branch5 and all downstream sections is
    %
    %    children = exampleCell.getchildren("branch5");
    %
    %    Warning: if using an older version of matlab where double-quoted
    %    strings are not supported. The following syntax is required
    %
    %    children = exampleCell.getchildren(string('branch5')); or
    %    children = exampleCell.getchildren('branch5');
    %
    % see also ELFENN.Cell ELFENN.Section
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('name', @(x) validateattributes(x, {'string', 'char'}, {}));
    p.parse(name);
    
    if ~isempty(this.connectivity)
        sections = [this.sections.name];
        child_ix = logical(this.connectivity(strcmp(sections, name), :));
        children = sections(child_ix);
    else
        children = [];
    end
    
    %------------- END OF CODE --------------
end