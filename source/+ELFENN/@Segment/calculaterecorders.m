function recorders = calculaterecorders(r, nAxes, style, varargin)
    %CALCULATERECORDERS - Calculate recorders for segment
    %THIS FUNCTION IS ONLY USED INTERNALLY: if you are reading this you likely
    %made a mistake
    %Given some parameters, calculate the recorders for a segment depending on
    %the style. WARNING: for spherical segments, the nAxes parameter is
    %ignored and the segments are taken on the surface of the sphere on each of
    %the 3 coordinate axes. Then rotated by 1.8*pi in the y axis and e*pi in
    %the z axis to ensure the recorders are not aligned with any segments
    %attached to it. TODO: Do this more effectively
    %
    % Inputs:
    %    r      - Segment radius (double)
    %    nAxes  - Number of equidistanct axes on the section diameter to include (integer)
    %    style  - Section geometry ('S', or 'C') (String)
    %    y      - Midpoint of cylinder on new basis (double)
    %
    % Outputs:
    %    recorders - List of coordinates for this segment (double array)
    %
    % Raises:
    %    None
    %
    % Example:
    %    radius = 5;
    %    nAxes = 3;
    %    style = 'C';
    %    midpoint = 50;
    %    recorders = calculaterecorders(radius, nAxes, style, midpoint);
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('r', @(x) validateattributes(x(:), {'numeric'}, {'positive', 'scalar'}));
    p.addRequired('nAxes', @(x) validateattributes(x(:), {'numeric'}, {'positive', 'integer', 'scalar'}));
    p.addRequired('style', @(x) any(strcmp(x, {'S', 'C'})));
    p.addOptional('y', -1, @(x) validateattributes(x(:), {'numeric'}, {'scalar'}));
    p.parse(r, nAxes, style, varargin{:});
    y = p.Results.y;
    
    if strcmp(style, 'C')
        recorders = zeros(2*nAxes, 3);
        angleStep = 2 * pi / (2 * nAxes);
        thetaArray = 0:angleStep:(2 * pi - angleStep);
        for ix = 1:length(thetaArray)
            theta = thetaArray(ix);
            recorders(ix, :) = [r * cos(theta), y, r * sin(theta)];
        end
    else
        % TODO THIS IS A VERY BAD HACK THIS PUTS AN ARB. SPIN ON
        % RECORDERS SO THEY`RE OUTSIDE AN AXON
        import Algorythm.transforms.*
        thetaZ = 1.8 * pi;
        thetaY = exp(1) * pi;
        temporaryRecorders = [-r, 0, 0; ...
            r, 0, 0; ...
            0, -r, 0; ...
            0, r, 0; ...
            0, 0, -r; ...
            0, 0, r];
        
        
        
        recorders = temporaryRecorders * (rotate_y(thetaY) * rotate_z(thetaZ));
    end
    
    %------------- END OF CODE --------------
end