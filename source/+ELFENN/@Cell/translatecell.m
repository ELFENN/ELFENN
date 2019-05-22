function translatecell(this, offset)
    %TRANSLATECELL - Move cell about space
    %This function does not check if cells are overlapping after the
    %translation. Care should be taken here as intersections/overlaps are not
    %checked
    %
    % Inputs:
    %    offset - Displacement vector (double array)
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
    %    exampleCell.translatecell([0,0,50]) % translate cell 50 microns in z
    %
    % see also ELFENN.Cell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('offset', @(x) validateattributes(x(:), {'numeric'}, ...
        {'size', [3, 1]}));
    
    
    
    p.parse(offset);
    
    for section = this.sections
        section.translatesection(offset); %TODO: check for overlapping cells
    end
    
    %------------- END OF CODE --------------
end