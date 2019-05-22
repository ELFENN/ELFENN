function calculatefinitedifference(this, cellBaseIndex)
    %CALCULATEFINITEDIFFERENCE - Compute the finite difference matrix
    %Eplicit axial current along the axon is given by FD*Vin where the finite
    %difference matrix represents effective conductivity between nodes. Base
    %index keeps track of indeces across cells
    %
    % Inputs:
    %    cellBaseIndex - Index offset for current cell (integer)
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
    %    exampleCell.calculatefinitedifference(1)
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
    
    if ~this.isDiscretized
        error('Cell is not discretized - Please run complete first')
    end
    
    FD = zeros(this.nTotalSeg, this.nTotalSeg);
    for row = 1:size(this.segmentConnectivityW, 1)
        connection = this.segmentConnectivityW(row, :);
        equivalentIndeces = this.segmentconnectivityIX(row, :);
        equivalentIndeces = equivalentIndeces - cellBaseIndex + 1;
        split = strsplit(connection(1), ' ');
        section1 = this.getsectionbyname(split(2));
        
        split = strsplit(connection(2), ' ');
        section2 = this.getsectionbyname(split(2));
        
        if strcmp(section1.name, section2.name)
            l = section1.segmentLength * 1e-4;
            ESR = section1.Ra * l / (pi * section1.radius^2 * 1e-4 * 1e-4);
        else
            ESR = section1.Ra * section1.segmentLength * 1e-4 * 0.5 / (pi * section1.radius^2 * 1e-4 * 1e-4);
            ESR = ESR + section2.Ra * section2.segmentLength * 1e-4 * 0.5 / (pi * section2.radius^2 * 1e-4 * 1e-4);
        end
        
        resistancedensity1 = 1e3 / (ESR) * 1 / (section1.segmentArea * 1e-4 * 1e-4);
        resistancedensity2 = 1e3 / (ESR) * 1 / (section2.segmentArea * 1e-4 * 1e-4);
        FD(equivalentIndeces(1), equivalentIndeces(2)) = resistancedensity1;
        FD(equivalentIndeces(2), equivalentIndeces(1)) = resistancedensity2;
    end
    
    for row = 1:length(FD) % sum diagonals
        FD(row, row) = -sum(FD(row, :));
    end
    
    this.resistivefdm = FD;
    
    %------------- END OF CODE --------------
end
