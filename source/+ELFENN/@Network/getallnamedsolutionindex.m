function solutionid = getallnamedsolutionindex(this, name)
    %GETALLNAMEDSOLUTIONINDEX - Get indeces of a particular variable
    %Returned incedes are the index in the variable dimension of the solution
    %matrix. Indeces are ordered (in a nested manner) by
    %Cell - Section - Segment.
    %
    % Inputs:
    %    variableName - Name of variable (String)
    %
    % Outputs:
    %    solutionID - Indeces of solutions (integer array)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network. It is also assumed that
    %    exampleNetwork has been completed.
    %
    %    solutionID = exampleNetwork.getallnamedsolutionindex("Vm")
    %
    %    Warning: if using an older version of matlab where double-quoted
    %    strings are not supported. The following syntax is required
    %
    %    solutionID = exampleNetwork.getallnamedsolutionindex('Vm') or
    %    solutionID = exampleNetwork.getallnamedsolutionindex(string('Vm'))
    %
    % see also exampleNetwork
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('name', @(x) validateattributes(x, {'string', 'char'}, {}));
    p.parse(name);
    
    solutionid = [];
    for cell = this.cells
        for section = cell.sections
            variablemap = [section.segments.ODEID];
            solutionid = [solutionid, variablemap.(name)];
        end
    end
    
    %------------- END OF CODE --------------
end