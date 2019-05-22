function [cellname, segment, varargout] = segmentclosestto(this, target, varargin)
    %SEGMENTCLOSESTTO - Find the segment closest to a point
    %
    % Inputs:
    %    target - Point to find nearest segment (numeric array)
    %    skip   - Cell to skip (optional)
    %
    % Outputs:
    %    segment      - Segment
    %    cellname     - Name of cell owning segment
    %    varargout(1) - distance
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork,if you do
    %    not please see ELFENN.Network
    %
    %    target = [0,0,100];
    %    segmentid = exampleNetwork.segmentclosestto(target);
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
    p.addOptional('skip', "", @(x) validateattributes(x, {'string', 'char'}, {}));
    p.parse(target, varargin{:});
    skip = p.Results.skip;
    
    allsegments = [];
    cellnames = [];
    segs = [];
    for cell = this.cells
        if ~strcmp(cell.name, skip)
            for section = cell.sections
                segmentposition = reshape([section.segments.position], 3, [])';
                allsegments = [allsegments; [segmentposition, [section.segments.connectivityid]']];
                cellnames = [cellnames; repmat(string(cell.name), size(segmentposition, 1), 1)];
                segs = [segs, section.segments];
            end
        end
    end
    
    dist = sqrt(sum((allsegments(:, 1:3) - target).^2, 2));
    [mdist, relativeid] = min(dist);
    %segmentid = allsegments(relativeid, 4);
    segment = segs(relativeid);
    cellname = cellnames(relativeid);
    varargout{1} = mdist;
    %this.cells = [this.cells, cell];
    
    %------------- END OF CODE --------------
end