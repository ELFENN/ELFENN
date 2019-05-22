function [h] = plotsegment(p1, p2, r, color)
    %PLOTSECTION - Plot segment
    %
    % Inputs:
    %    section - Section object (ELFENN.Section)
    %    color   - Color to make section (valid MATLAB color)
    %
    % Outputs:
    %    h - Handle to patch object (patch)
    %
    % see also plotnetwork, plotcell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    %     p = inputParser;
    %     p.addRequired('section', @(x) validateattributes(x, {'ELFENN.Section'},{}));
    %     p.addParameter('color', 'k', @(x) validateattributes(x, {'string','char', 'double'},{}));
    %     p.parse(section,color);
    %
    %     color = p.Results.color;
    
    
    vector = p2 - p1;
    scale = norm(vector);
    R = getrotationmatrixofvector(vector/scale);
    [x, y, z] = cylinder(r);
    sz = size(x);
    temp = [x(:), scale * z(:), y(:)] * (R).';
    x = reshape(temp(:, 1), sz) + p1(1);
    y = reshape(temp(:, 2), sz) + p1(2);
    z = reshape(temp(:, 3), sz) + p1(3);
    
    
    h = surf(x, y, z, 'FaceColor', color);
    set(h, 'linestyle', 'none');
    daspect([1, 1, 1]);
    
    %------------- END OF CODE --------------
end
