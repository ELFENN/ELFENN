function complete(this)
    %COMPLETE - Compile the network
    %Complete each cell in the network which involves discretizing and
    %internally connecting each cell
    %
    % Inputs:
    %    None
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network.
    %
    %    exampleNetwork.complete()
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    if this.isDiscretized
        error('Network already discretized');
    end
    
    cellBaseIndex = 1;
    for cell = this.cells
        cellBaseIndex = cell.complete(cellBaseIndex);
    end
    this.calculatefdm();
    this.gapjunctionfdm = sparse(zeros(this.nTotalSeg, this.nTotalSeg));
    
    this.isDiscretized = 1;
    %------------- END OF CODE --------------
end