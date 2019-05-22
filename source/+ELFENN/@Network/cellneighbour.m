function [cellname, segmentid1, segmentid2] = cellneighbour(this, celltarget)
    %SEGMENTCLOSESTTO - Find the segment closest to a point on two cells
    %Finds segments on two different cells nearest to a point. This serves to
    %connect cells with gap junctions
    %
    % Inputs:
    %    celltarget - Cell to find neighbour of (string)
    %
    % Outputs:
    %    cellname1  - Name of cell owning segment1
    %    cellname2  - Name of cell owning segment2
    %    segment1   - Segment id of nearest segment on second cell
    %    segment2   - Segment id of nearest segment
    %
    % Raises:
    %    Error - If there is only 1 cell
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork,if you do
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
    p.addRequired('celltarget', @(x) validateattributes(x, {'string', 'char'}, {}));
    p.parse(celltarget);
    
    if length(this.cells) < 2
        Error('Need more than 1 cell');
    end
    
    celltarget = this.getcellbyname(celltarget);
    
    mindist = 1e6;
    mincell = "";
    minsegparent = 0;
    minseg = 0;
    
    for targetsection = celltarget.sections
        for seg = targetsection.segments
            [cellname, segmentid, d] = this.segmentclosestto(seg.position, celltarget.name);
            if d < mindist
                mincell = cellname;
                minsegparent = seg.connectivityid;
                minseg = segmentid;
                mindist = d;
            end
        end
    end
    
    segmentid1 = minsegparent;
    segmentid2 = minseg;
    cellname = mincell;
    
    %this.cells = [this.cells, cell];
    
    %------------- END OF CODE --------------
end