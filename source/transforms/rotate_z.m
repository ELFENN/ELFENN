function R = rotate_z(theta)
    %ROTATE_Z - Rotation matrix for Z-axis
    %
    % Inputs:
    %    theta - Angle in radians (double)
    %
    % Outputs:
    %    R - Z-rotation matrix
    %
    % Example:
    %    z_rotation = rotate_z(pi);
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    R = [cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0; 0, 0, 1];
    
    %------------- END OF CODE --------------
end
