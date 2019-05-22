function R = rotate_y(theta)
    %ROTATE_Y - Rotation matrix for Y-axis
    %
    % Inputs:
    %    theta - Angle in radians (double)
    %
    % Outputs:
    %    R - Y-rotation matrix
    %
    % Example:
    %    y_rotation = rotate_z(pi);
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    R = [cos(theta), 0, sin(theta); 0, 1, 0; -sin(theta), 0, cos(theta)];
    
    %------------- END OF CODE --------------
end
