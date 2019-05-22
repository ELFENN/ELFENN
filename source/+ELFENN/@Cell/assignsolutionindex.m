function assignsolutionindex(this, names)
    %ASSIGNSOLUTIONINDEX - Assign indeces in solution for each dynamic variable
    %Output of simulation will have a shape (M,N) where M is the number of time
    %points and N is the number of dyanmic variables. This function maps each
    %segment of the cell and their corresponding variables to the corresponding
    %index (column) in the solution
    %
    % Inputs:
    %    names - list of variable names, with Vm first (String array)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    Error - if the first element in the name list is not "Vm"
    %
    % Example:
    %    Assuming you already have a cell named exampleCell, if you do not
    %    please see ELFENN.Cell.
    %
    %    This example assumes that the ODE you are solving has variables named
    %        - Vm
    %        - m
    %        - h
    %        - n
    %
    %    exampleCell.assignsolutionindex(["Vm", "m", "h", "n"])
    %
    %    Warning: if using an older version of matlab where double-quoted
    %    strings are not supported. The following syntax is required
    %
    %    exampleCell.assignsolutionindex([string('Vm'), string('m'),
    %    string('h'), string('n')])
    %
    % see also ELFENN.Cell
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('names', @(x) validateattributes(x, {'string'}, {}));
    p.parse(names);
    
    if ~strcmp(names(1), 'Vm')
        error('Vm is not specified as the first ODE variable')
    end
    
    nDynamicVariables = length(names);
    for section = this.sections
        for segment = section.segments
            segment.ODEID.Vout = (1 + nDynamicVariables) * (segment.connectivityid - 1) + 1;
            offset = 2;
            for name = names
                segment.ODEID.(char(name)) = (1 + nDynamicVariables) * (segment.connectivityid - 1) + offset;
                offset = offset + 1;
            end
        end
    end
    
    %------------- END OF CODE --------------
end