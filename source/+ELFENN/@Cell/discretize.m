function discretize(this)
    %discretize - Discretize cell
    %Discretize each section in the cell into equal sized segments given
    %specified number of segments
    %
    % Inputs:
    %    None
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    Error - If cell is already discretized
    %
    % Example:
    %    Assuming you already have a cell named exampleCell, if you do not
    %    please see ELFENN.Cell.
    %
    %    exampleCell.discretize();
    %
    % see also ELFENN.Cell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    if this.isDiscretized
        Error('Cell is already discretized');
    end
    
    this.isDiscretized = 1;
    for section = this.sections
        section.discretize();
    end
    
    %------------- END OF CODE --------------
end