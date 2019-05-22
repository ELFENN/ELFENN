function newCellBaseIndex = complete(this, cellBaseIndex)
    %COMPLETE - Discretize and internally connect a cell
    %Discretizing involves breaking up a section into segments and connecting
    %builds an adjacency matrix for the newly created segments
    %
    % Inputs:
    %    cellBaseIndex     - Index offset for current cell (integer)
    %
    % Outputs:
    %    newCellBaseIndex - Index offset for next cell (integer)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a cell named exampleCell, if you do not
    %    please see ELFENN.Cell.
    %
    %    exampleCell.complete(1)
    %
    % see also ELFENN.Cell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('cellbaseindex', @(x) validateattributes(x, ...
        {'numeric'}, {'positive', 'nonempty', 'integer'}));
    
    
    
    p.parse(cellBaseIndex);
    
    if this.isDiscretized
        error('Cell has already been discretized')
    end
    
    this.discretize()
    newCellBaseIndex = this.calculatefullconnectivity(cellBaseIndex);
    this.calculatefinitedifference(cellBaseIndex);
    this.labelconnectivityid(cellBaseIndex);
    
    %------------- END OF CODE --------------
end
