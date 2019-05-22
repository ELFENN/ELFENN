function plotcell(cell, varargin)
    %PLOTCELL - Plot cell
    %
    % Inputs:
    %    Cell  - Cell object (ELFENN.Cell)
    %    style - Type of plot "cyl" or "line" (String)
    %    color - Color to make section (valid MATLAB color)
    %
    % Outputs:
    %    h - Handle to patch object (patch)
    %
    % Example (default plot):
    %    plotcell(cell)
    %
    % Example (line plot):
    %    plotcell(cell, 'style', 'line')
    %
    % Example (set color):
    %    plotcell(cell, 'color', 'r')
    %
    % see also plotnetwork, plotcell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('cell', @(x) validateattributes(x, {'ELFENN.Cell'}, {}));
    p.addParameter('style', 'cyl', @(x) any([strcmp(x, 'line'), strcmp(x, 'cyl')]));
    p.addParameter('color', 'k', @(x) validateattributes(x, {'string', 'char', 'double'}, {}));
    p.parse(cell, varargin{:});
    
    style = p.Results.style;
    color = p.Results.color;
    
    hold all;
    for section = cell.sections
        plotsection(section, 'style', style, 'color', color);
    end
    
    daspect([1, 1, 1]);
    
    %------------- END OF CODE --------------
end
