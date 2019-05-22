function cellBaseIndex = calculatefullconnectivity(this, cellBaseIndex)
    %CALCULATEFULLCONNECTIVITY - Calculate connectivity matrix of cell
    %Calculate the connectivity of each node (segment) in the cell. This will
    %be used as part of the finite difference matrix equation. An offset in
    %indexing is used to keep track of indeces across cells.
    %
    % Inputs:
    %    cellBaseIndex - Index offset for current cell (integer)
    %
    % Outputs:
    %    cellBaseIndex - Index offset for next cell (integer)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a cell named exampleCell, if you do not
    %    please see ELFENN.Cell.
    %
    %    exampleCell.calculatefullconnectivity(1)
    %
    % see also ELFENN.Cell
    
    % As a note to anyone reading this code and questioning the sanity of using
    % string identifiers for working out the graph connectivity. This is not
    % ideal and a relatively expensive opperation. However it is easy to test
    % and compared to the cost of the simulation it is negligable.
    %
    %
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
    
    totalsegments = sum([this.sections.nSeg]);
    nsegmentsadded = 1;
    nconnectionsadded = 1;
    
    uniquenamesarray = strings(totalsegments, 1);
    % preallocating connection list: extra long for memory
    segmentconnectionarray = strings(totalsegments*5, 2);
    
    % Connect segments within a section and create unique segment names
    % sectionName segmentName
    for section = [this.sections]
        uniquenames = this.name + string(' ') + section.name + string(' ') + [section.segments.name];
        uniquenamesarray(nsegmentsadded:nsegmentsadded+length(uniquenames)-1) = uniquenames;
        
        indeces = find(section.connectivity(:));
        % if the section has any connected segments
        if ~isempty(indeces)
            [row, col] = ind2sub(size(section.connectivity), indeces);
            segmentconnectionarray(nconnectionsadded:(nconnectionsadded + length(row) - 1), :) ...
                = [uniquenames(row)', uniquenames(col)'];
            
            
            
            nconnectionsadded = nconnectionsadded + length(row);
        end
        nsegmentsadded = nsegmentsadded + length(uniquenames);
    end
    
    % Start connecting sections. End of parent connects to beginning of child.
    indeces = find(this.connectivity(:));
    [row, col] = ind2sub(size(this.connectivity), indeces);
    
    for ix = 1:length(row)
        parent = this.getsectionbyname(this.sectionNames(row(ix)));
        parentuniquename = this.name + string(' ') + parent.name + string(' ') + parent.segments(end).name;
        child = this.getsectionbyname(this.sectionNames(col(ix)));
        childuniquename = this.name + string(' ') + child.name + string(' ') + child.segments(1).name;
        segmentconnectionarray(nconnectionsadded, :) = [parentuniquename, childuniquename];
        nconnectionsadded = nconnectionsadded + 1;
    end
    
    % Shrink back segmentconnections
    segmentconnectionarray = segmentconnectionarray(1:nconnectionsadded-1, :);
    
    keyset = cellstr(uniquenamesarray);
    valueset = 1:length(keyset);
    valueset = valueset + cellBaseIndex - 1;
    map = containers.Map(keyset, valueset);
    f = @(v) map(char(v));
    segmentconnectionsix = arrayfun(f, segmentconnectionarray);
    
    this.segmentConnectivityW = segmentconnectionarray;
    this.segmentconnectivityIX = segmentconnectionsix;
    cellBaseIndex = cellBaseIndex + length(keyset);
    
    %------------- END OF CODE --------------
end