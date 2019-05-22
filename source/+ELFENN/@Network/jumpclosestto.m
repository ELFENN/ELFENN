function [cellname1, cellname2, segment1, segment2] = jumpclosestto(this, target)
    %SEGMENTCLOSESTTO - Find the segment closest to a point on two cells
    %Finds segments on two different cells nearest to a point. This serves to
    %connect cells with gap junctions
    %
    % Inputs:
    %    target - Point to find nearest segment (numeric array)
    %
    % Outputs:
    %    cellname1  - Name of cell owning segment1
    %    cellname2  - Name of cell owning segment2
    %    segment1   - Nearest segment on first cell
    %    segmend2   - Nearest segment on second cell
    %
    % Raises:
    %    Error - If there is only 1 cell
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network
    %
    %    target = [0,0,100];
    %    segmentids = exampleNetwork.jumpclosestto(target);
    %
    % see also ELFENN.Network ELFENN.Segment
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('target', @(x) validateattributes(x, {'numeric'}, {'vector', 'numel', 3}));
    p.parse(target);
    
    if length(this.cells) < 2
        Error('Need more than 1 cell');
    end
    
    [cellname1, segment1] = this.segmentclosestto(target);
    [cellname2, segment2] = this.segmentclosestto(target, cellname1);
    
    %this.cells = [this.cells, cell];
    
    %------------- END OF CODE --------------
end