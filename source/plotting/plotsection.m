function [h] = plotsection(section, varargin)
    %PLOTSECTION - Plot section
    %
    % Inputs:
    %    section - Section object (ELFENN.Section)
    %    style   - Type of plot "cyl" or "line" (String)
    %    color   - Color to make section (valid MATLAB color)
    %
    % Outputs:
    %    h - Handle to patch object (patch)
    %
    % Example (default plot):
    %    plotsection(section)
    %
    % Example (line plot):
    %    plotsection(section, 'style', 'line')
    %
    % Example (set color):
    %    plotsection(section, 'color', 'r')
    %
    % see also plotnetwork, plotcell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('section', @(x) validateattributes(x, {'ELFENN.Section'}, {}));
    p.addParameter('style', 'cyl', @(x) any([strcmp(x, 'line'), strcmp(x, 'cyl')]));
    p.addParameter('color', 'k', @(x) validateattributes(x, {'string', 'char', 'double'}, {}));
    p.parse(section, varargin{:});
    
    style = p.Results.style;
    color = p.Results.color;
    
    if strcmp(style, 'line')
        if section.isCylinder
            
            plot3([section.startPoint(1), section.endPoint(1)], ...
                [section.startPoint(2), section.endPoint(2)], ...
                [section.startPoint(3), section.endPoint(3)], 'color', color);
            
            
            
        else
            
            %         center = (section.startPoint + section.endPoint)/2;
            %         [px, py, pz] = plot_sphere_line(center, section.radius);
            %         scatter3(px, py, pz, color);
            
            [x, y, z] = sphere;
            x = x * section.radius;
            y = y * section.radius;
            z = z * section.radius;
            center = mean([section.endPoint; section.startPoint]);
            
            
            h = surf(x+center(1), y+center(2), z+center(3), 'FaceColor', color);
            set(h, 'linestyle', 'none')
        end
    else
        if section.isCylinder
            vector = section.endPoint - section.startPoint;
            scale = norm(vector);
            R = getrotationmatrixofvector(vector/scale);
            [x, y, z] = cylinder(section.radius);
            sz = size(x);
            temp = [x(:), scale * z(:), y(:)] * (R).';
            x = reshape(temp(:, 1), sz) + section.startPoint(1);
            y = reshape(temp(:, 2), sz) + section.startPoint(2);
            z = reshape(temp(:, 3), sz) + section.startPoint(3);
            
            if ~isempty(find(strcmp(p.UsingDefaults, 'color'), 1))
                h = surf(x, y, z);
            else
                h = surf(x, y, z, 'FaceColor', color);
            end
            set(h, 'linestyle', 'none');
        else
            [x, y, z] = sphere;
            x = x * section.radius;
            y = y * section.radius;
            z = z * section.radius;
            center = mean([section.endPoint; section.startPoint]);
            
            
            h = surf(x+center(1), y+center(2), z+center(3), 'FaceColor', color);
            set(h, 'linestyle', 'none')
        end
    end
    daspect([1, 1, 1]);
    
    %------------- END OF CODE --------------
end
