function R = getrotationmatrixofvector(vector)
    %GETROTATIONMATRIXOFVECTOR - Matrix to line up vector with y axis
    %Get matrix (A) such that Av is parallel to y axis
    %
    % Inputs:
    %    vector - 3-vector to rotate (double array)
    %
    % Outputs:
    %    R - rotation matrix
    %
    % Example:
    %    R = getrotationmatrixofvector([1, pi, -12)
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    vector = vector / norm(vector);
    if abs(vector) == [0, 1, 0]
        R = eye(3) / norm(vector);
        if vector(2) == -1
            R = -R;
        end
    else
        basis = [0, 1, 0]; % line in y axis
        
        v = cross(vector, basis);
        ssc = [0, -v(3), v(2); v(3), 0, -v(1); -v(2), v(1), 0];
        R = eye(3) + ssc + ssc^2 * (1 - dot(vector, basis)) / (norm(v))^2;
        R = inv(R);
    end
    
    %------------- END OF CODE --------------
end
