function appendsection(this, child)
    %APPENDSECTION - Add sections onto a cell
    %Helper function for maintaining the internal list of sections belonging to
    %a cell
    %
    % Inputs:
    %    child - child to add to cell (ELFENN.Section)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a cell named exampleCell, and a section
    %    named exampleSection, if you do not please see ELFENN.Cell, and
    %    ELFENN.Section
    %
    %    exampleCell.appendsection(exampleSection)
    %
    % see also ELFENN.Cell ELFENN.Section
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('child', @(x) validateattributes(x, {'ELFENN.Section'}, {}));
    p.parse(child);
    
    this.sections = [this.sections, child];
    
    %------------- END OF CODE --------------
end