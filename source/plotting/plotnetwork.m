function plotnetwork(network, varargin)
    %PLOTNETWORK - Plot network
    %
    % Inputs:
    %    Network - Network object (ELFENN.Network)
    %    style   - Type of plot "cyl" or "line" (String)
    %    color   - Color to make section (valid MATLAB color)
    %
    % Outputs:
    %    h - Handle to patch object (patch)
    %
    % Example (default plot):
    %    plotnetwork(network)
    %
    % Example (line plot):
    %    plotnetwork(network, 'style', 'line')
    %
    % Example (set color):
    %    plotnetwork(network, 'color', 'r')
    %
    % see also plotsection, plotcell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('network', @(x) validateattributes(x, {'ELFENN.Network'}, {}));
    p.addParameter('style', 'cyl', @(x) any([strcmp(x, 'line'), strcmp(x, 'cyl')]));
    p.addParameter('color', 'k', @(x) validateattributes(x, {'string', 'char', 'double'}, {}));
    p.parse(network, varargin{:});
    
    style = p.Results.style;
    color = p.Results.color;
    
    hold all
    for cell = network.cells
        plotcell(cell, 'style', style, 'color', color);
    end
    
    daspect([1, 1, 1]);
    
    %------------- END OF CODE --------------
end
