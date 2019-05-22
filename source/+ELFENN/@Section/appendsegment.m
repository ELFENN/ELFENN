function appendsegment(this, segment)
    %APPENDSEGMENT - Add a segment onto a section
    %Helper function for maintaining the internal list of segments
    %belonging to a section
    %
    % Inputs:
    %    segment - Segment to add to section (ELFENN.Segment)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a section named exampleSection, and a
    %    segment named exampleSegment, if you do not please see
    %    ELFENN.Section, and  ELFENN.Segment.
    %
    %    exampleSection.appendsegment(exampleSegment)
    %
    % see also ELFENN.Section ELFENN.Segment
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('segment', @(x) validateattributes(x, {'ELFENN.Segment'}, {}));
    p.parse(segment);
    
    this.segments = [this.segments, segment];
    
    %------------- END OF CODE --------------
end