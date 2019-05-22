function addcell(this, cell, varargin)
    %ADDCELL - Add a cell into the network
    %Add cell into a network with an offset. Note care must be taken here as
    %ELFENN does not check for colisions
    %
    % Inputs:
    %    cell   - Cell to add (ELFENN.Cell)
    %    offset - Displacement vector (double array, optional)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    Warning - If no offset is specified
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, and a cell
    %    name exampleCell, if you do not please see ELFENN.Network, and
    %    ELFENN.Cell.
    %
    %    offset = [0,0,100]; % translate 100um in z;
    %    exampleNetwork.addcell(exampleCell, offset)
    %
    % see also ELFENN.Network ELFENN.Cell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('cell', @(x) validateattributes(x, {'ELFENN.Cell'}, {}));
    p.addOptional('offset', -1, @(x) validateattributes(x, {'numeric'}, {'vector', 'numel', 3}));
    
    p.parse(cell, varargin{:});
    offset = p.Results.offset;
    cell = cell.copy();
    
    if offset ~= -1
        cell.translatecell(offset);
    else
        warning('No cell offset specified: cell will be placed at origin');
        %TODO check for overlapping cells
    end
    this.cells = [this.cells, cell];
    
    %------------- END OF CODE --------------
end