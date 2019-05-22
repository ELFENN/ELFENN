function connectsegment(this, segment1, varargin)
    %CONNECTSEGMENT - Connect 2 segments together
    %
    % Inputs:
    %    segment1 - Parent segment (ELFENN.Segment)
    %    segment2 - Child segment (ELFENN.Segment, optional)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    error - If second segment is not added (single segment section)
    %
    % Example:
    %    Assuming you already have a section named exampleSection, and segments
    %    named exampleSegment1, exampleSegment2, if you do not please see
    %    ELFENN.Section, and  ELFENN.Segment.
    %
    %    exampleSection.connectsegment(exampleSegment1, exampleSegment2);
    %
    % see also ELFENN.Section, ELFENN.Segment
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('segment1', @(x)validateattributes(x, {'ELFENN.Segment'}, {}));
    p.addOptional('segment2', -1, @(x)validateattributes(x, {'ELFENN.Segment'}, {}));
    p.parse(segment1, varargin{:});
    
    segment2 = p.Results.segment2;
    if isempty(this.segments)
        this.segments = segment1;
    elseif segment2 == -1
        error('Adding segment without base');
    else
        this.appendsegment(segment2);
        ix1 = find([this.segments.name] == segment1.name);
        ix2 = find([this.segments.name] == segment2.name);
        
        this.connectivity(ix1, ix2) = 1;
        this.connectivity(ix2, ix1) = 0;
    end
    
    %------------- END OF CODE --------------
end