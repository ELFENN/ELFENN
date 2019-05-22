function plot_dynamics_on_neuron(network, y, variable, timeIx, map)
    %PLOT_DYNAMICS_ON_NEURON - Plot a network colored by a dynmical variable
    %Currently resolution is limited to the section levels (dynamics are
    %averaged over all segment of a section).
    %
    % Inputs:
    %    network  - Network object (ELFENN.Network)
    %    y        - Solution (double array)
    %    variable - Name of variable (String)
    %    timeIx   - Index of time to plot (integer)
    %    map      - Colormap handle (function handle)
    %
    % Outputs:
    %    None
    %
    % Example (default plot):
    %    Assuming solution has already been run, if not see ELFENN.Network
    %    and ELFENN.Solver
    %
    %    plot_dynamics_on_neuron(network, results, 'Vm', 153, @hot)
    %
    % see also ELFENN.Network ELFENN.Solver
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    variable_ix = network.getallnamedsolutionindex(variable);
    data = y(timeIx, :);
    
    color_handle = create_colormap(data(variable_ix), 50, map);
    mx = -1000;
    mn = 1000;
    hold all
    mn = 1e6;
    mx = -1e6;
    for cell = network.cells
        for section = cell.sections
            p1 = section.startPoint;
            p2 = section.endPoint;
            v = p2 - p1;
            spacing = v / length(section.segments);
            for ix = 1:length(section.segments)
                id = section.segments(ix).ODEID.(variable);
                c = data(id);
                
                if c > mx
                    mx = c;
                end
                
                if c < mn
                    mn = c;
                end
                color = color_handle(c);
                
                if section.isCylinder
                    plotsegment(p1+(ix - 1)*spacing, p1+(ix)*spacing, section.radius, color);
                else
                    plotsection(section, 'color', color);
                end
            end
        end
    end
    caxis([mn, mx]);
    colormap(map(150));
    colorbar;
    %------------- END OF CODE --------------
end
