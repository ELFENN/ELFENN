function rotateoffsoma(this, name)
    %ROTATEOFFSOMA - Fix angles of branches originating at the soma
    %When sections are added to the soma, and a soma angle is specified, the
    %branches are not aranged with their angles properly. This is generally the
    %last opperation to be done when adding geometries - and should only be
    %called once.
    %
    % Inputs:
    %    name - Name of soma section (String)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a cell named exampleCell, if you do not
    %    please see ELFENN.Cell.
    %
    %    exampleCell.rotateoffsoma('soma')
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
    
    childarray = this.getchildren(name);
    for ix = 1:length(childarray)
        child = this.getsectionbyname(childarray(ix));
        this.rotatechunk(child.name, child.somaAngle);
    end
    
    %------------- END OF CODE --------------
end