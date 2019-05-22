function R = rotate_x(theta)
    %ROTATE_X - Rotation matrix for X-axis
    %
    % Inputs:
    %    theta - Angle in radians (double)
    %
    % Outputs:
    %    R - X-rotation matrix
    %
    % Example:
    %    x_rotation = rotate_x(pi);
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    R = [1, 0, 0; 0, cos(theta), -sin(theta); 0, sin(theta), cos(theta)];
    
    %------------- END OF CODE --------------
end
