function labelconnectivityid(this, cellBaseIndex)
    %LABELCONNECTIVITYID - Assign each segment an index in global connectivity
    %Each segment in the cell is mapped onto an index in the finite difference
    %matrix for the entire network,
    %
    % Inputs:
    %    cellBaseIndex - Index offset for current cell only used as a hack for single compartment cells (integer)
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
    %    exampleCell.labelconnectivityid(1)
    %
    % see also ELFENN.Cell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('cellBaseIndex', @(x) validateattributes(x, ...
        {'numeric'}, {'positive', 'nonempty', 'integer'}));
    
    
    
    p.parse(cellBaseIndex);
    
    if this.nTotalSeg == 1 % special case for single compartment
        this.sections(1).segments(1).connectivityid = cellBaseIndex;
    end
    
    sectionSegmentPairs = this.segmentConnectivityW(:);
    segmentIdArray = this.segmentconnectivityIX(:);
    
    for ix = 1:length(segmentIdArray)
        nameParts = split(sectionSegmentPairs(ix), ' ');
        sectionName = nameParts(2);
        segmentName = nameParts(3);
        
        segment = this.getsectionbyname(sectionName).getsegmentbyname(segmentName);
        segment.connectivityid = segmentIdArray(ix);
    end
    
    %------------- END OF CODE --------------
end