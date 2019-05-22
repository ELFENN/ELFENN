function calculatefdm(this)
    %CALCULATEFDM - calculate the finite difference matrix for the network
    %Caluclates the equivalent FD matrix for the entire network. Without gap
    %junctions this is a block diagonal matrix of the FD matrix of each cell
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
    %    exampleNetwork.calculatefdm()
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    FD = blkdiag([]);
    for cell = this.cells
        FD = blkdiag(FD, cell.resistivefdm);
    end
    this.resistivefdm = sparse(FD);
    
    %------------- END OF CODE --------------
end