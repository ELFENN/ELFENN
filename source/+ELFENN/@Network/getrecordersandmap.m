function [recorders, map] = getrecordersandmap(this)
    %GETRECORDERSANDMAP - Get a list of recorders and their map
    %Get a list of all recorders (where to record Vout from) and the map of
    %which recorders go to which segments.
    %
    % Inputs:
    %    None
    %
    % Outputs:
    %    recorders - List of recorder coordinates (double array)
    %    map       - Map of indeces of segments to map recorders to (integer array)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network.
    %
    %    [recorders, map] = exampleNetwork.getrecordersandmap()
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    recorders = [];
    map = [];
    nAdded = 1;
    for cell = this.cells
        for section = cell.sections
            for segment = section.segments
                r = segment.recorders;
                recorders = [recorders; r];
                map = [map; [nAdded, (nAdded + size(r, 1) - 1)]];
                nAdded = nAdded + size(r, 1);
            end
        end
    end
    
    %------------- END OF CODE --------------
end