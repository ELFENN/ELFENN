function segment = getsegmentbyid(this, id)
    %SEARCHSECTIONBYSEG - Get section handle of segment by id
    %Returns the section which contains the specified segment id - used in
    %attaching processes to a segment and section information is needed (area)
    %
    % Inputs:
    %    id - Segment id
    %
    % Outputs:
    %    section - Section containing the segment (ELFENN.Section)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network.
    %
    %    section = exampleNetwork.sectionsearchbyseg(1)
    %
    % see also ELFENN.Network ELFENN.Section ELFENN.Segment
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    for c = this.cells
        for sec = c.sections
            ids = cell2mat({sec.segments.connectivityid});
            if ismember(id, ids)
                segment = sec.segments(ids == id);
                return
            end
        end
    end
    
    %------------- END OF CODE --------------
end