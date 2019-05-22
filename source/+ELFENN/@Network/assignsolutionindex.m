function assignsolutionindex(this, varargin)
    %ASSIGNSOLUTIONINDEX - Assign indeces in solution for each dynamic variable
    %Output of simulation will have a shape (M,N) where M is the number of time
    %points and N is the number of dyanmic variables. This function assigns the
    %correct indeces to each cell in the network
    %
    % Inputs:
    %    names - list of variable names, with Vm first, each name is another argument
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    Error - if the first element in the name list is not "Vm"
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network.
    %
    %    This example assumes that the ODE you are solving has variables named
    %        - Vm
    %        - m
    %        - h
    %        - n
    %
    %    exampleNetwork.assignsolutionindex("Vm", "m", "h", "n")
    %
    %    Warning: if using an older version of matlab where double-quoted
    %    strings are not supported. The following syntax is required
    %
    %    exampleNetwork.assignsolutionindex(string('Vm'), string('m'),
    %    string('h'), string('n'))
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    % p = inputParser;
    % p.addRequired('names', @(x) validateattributes(x, {'string'},{}));
    % p.parse(names);
    
    try
        names = string(varargin);
    catch
        error('Variables must be strings of chars');
    end
    
    if ~strcmp(names(1), 'Vm')
        error('Vm is not specified as the first ODE variable')
    end
    for cell = this.cells
        cell.assignsolutionindex(names);
    end
    
    %------------- END OF CODE --------------
end