function [r, l, p, v, s] = getlfpparameters(this)
    %getlfpparameters - Get all parameters required to calculate LFP
    %Get a set of all morphological parameters for each segments required to
    %calculate the LFP and basis transforms.
    %
    % Inputs:
    %    None
    %
    % Outputs:
    %    r   - Radius of each segment (double array)
    %    l   - Length of each segment (double array)
    %    p   - Position of each segment (double array)
    %    v   - Vector representing the orientation of the segment (double array)
    %    s   - Style of each segment (String array)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network.
    %
    %    [r, l, p, v, s] = exampleNetwork.getlfpparameters()
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    r = zeros(this.nTotalSeg, 1);
    l = zeros(this.nTotalSeg, 1);
    p = zeros(this.nTotalSeg, 3);
    v = zeros(this.nTotalSeg, 3);
    s = zeros(this.nTotalSeg, 1);
    
    ix = 1;
    for cell = this.cells
        for section = cell.sections
            for segment = section.segments
                % 1e-6 scaling converts from um to m: physics part uses SI
                r(ix) = section.radius * 1e-6;
                l(ix) = section.segmentLength * 1e-6;
                p(ix, :) = segment.position * 1e-6;
                v(ix, :) = (section.endPoint - section.startPoint) * 1e-6;
                s(ix) = section.isCylinder;
                ix = ix + 1;
            end
        end
    end
    
    %------------- END OF CODE --------------
end