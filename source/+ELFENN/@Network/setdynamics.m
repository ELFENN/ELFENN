function setdynamics(this, p)
    %SETDYNAMICS - Set dynamical parameters for a segment
    %Set the dynamical parameters: ENa, GK, ... for all segments in a network.
    %Different segments can be altered down the line
    %
    % Inputs:
    %    p - Parameters (struct)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork,if you do
    %    not please see ELFENN.Network
    %
    %    p = ELFENN.Mechanisms.Cellular.FS.default_parameters;
    %    exampleNetwork.setdynamics(p);
    %
    % see also ELFENN.Network ELFENN.Segment
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    if ~this.isDiscretized
        error('Network must first be completed');
    end
    
    for c = this.cells
        for s = c.sections
            s.dynamicsParameters = p;
        end
    end
    
    %------------- END OF CODE --------------
end
