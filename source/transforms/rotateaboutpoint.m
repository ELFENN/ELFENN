function rotatedCoordinates = rotateaboutpoint(coordinates, p, t)
    %ROTATEABOUTPOINT - rotate a set of coordinates about a point
    %
    % Inputs:
    %    coordinates - coordinates to rotate (double array)
    %    p           - point to rotate about (double array)
    %    t           - Euler angles of rotation (double array)
    %
    % Outputs:
    %    coordiantes_r - rotated coordinates
    %
    % Example:
    %    coordinates = [0,0,0; 1,1,1; 1,2,pi];
    %    coordinates_rotated = rotateaboutpoint(coordinates, [0,-1, exp(1)],pi/2];
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    x = coordinates(:, 1) - p(1);
    y = coordinates(:, 2) - p(2);
    z = coordinates(:, 3) - p(3);
    
    xyz = [x'; y'; z'];
    
    xyz = (rotate_z(t(3)) * rotate_y(t(2)) * rotate_x(t(1))) * xyz;
    
    xyz(1, :) = xyz(1, :) + p(1);
    xyz(2, :) = xyz(2, :) + p(2);
    xyz(3, :) = xyz(3, :) + p(3);
    rotatedCoordinates = xyz';
    
    %------------- END OF CODE --------------
end
