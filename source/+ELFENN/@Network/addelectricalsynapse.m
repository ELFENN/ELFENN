function addelectricalsynapse(this, index1, index2, conductance)
    %ADDELECTRICALSYNAPSE - Create a gap junction
    %Add a gap junction between 2 segments with a given conductance
    %
    % Inputs:
    %    index1      - Index of first segment (integer)
    %    index2      - Index of second segment (integer)
    %    conductance - Gap junction conducatance (mS)
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
    %    ix1 = exampleNetwork.cells(1).tip;
    %    ix2 = exampleNetwork.cells(2).tip;
    %    exampleNetwork.addelectricalsynapse(ix1, ix2, a1, a2, 0.000006);
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('index1', @(x) validateattributes(x, {'numeric'}, {'positive', 'nonempty', 'integer'}));
    p.addRequired('index2', @(x) validateattributes(x, {'numeric'}, {'positive', 'nonempty', 'integer'}));
    p.addRequired('conductance', @(x) validateattributes(x, {'numeric'}, {'positive', 'nonempty'}));
    p.parse(index1, index2, conductance);
    
    a1 = this.sectionsearchbyseg(index1).segmentArea;
    a2 = this.sectionsearchbyseg(index2).segmentArea;
    
    this.gapjunctionfdm(index1, index2) = this.gapjunctionfdm(index1, index2) + conductance / (a1 * 1e-4 * 1e-4);
    this.gapjunctionfdm(index1, index1) = this.gapjunctionfdm(index1, index1) - conductance / (a1 * 1e-4 * 1e-4);
    
    this.gapjunctionfdm(index2, index1) = this.gapjunctionfdm(index2, index1) + conductance / (a2 * 1e-4 * 1e-4);
    this.gapjunctionfdm(index2, index2) = this.gapjunctionfdm(index2, index2) - conductance / (a2 * 1e-4 * 1e-4);
    
    %------------- END OF CODE --------------
end