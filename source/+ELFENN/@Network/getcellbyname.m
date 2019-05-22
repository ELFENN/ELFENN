function cell = getcellbyname(this, name)
    %GETCELLBYNAME - Get handle to cell of given name
    %
    % Inputs:
    %    name - Name of cell (String)
    %
    % Outputs:
    %    cell - Handle to cell (ELFENN.Cell)
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network.
    %
    %    cell = exampleNetwork.getcellbyname("soma")
    %
    %    Warning: if using an older version of matlab where double-quoted
    %    strings are not supported. The following syntax is required
    %
    %    cell = exampleNetwork.getallnamedsolutionindex('soma') or
    %    cell = exampleNetwork.getallnamedsolutionindex(string('soma'))
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('name', @(x) validateattributes(x, {'string', 'char'}, {}));
    p.parse(name);
    
    found = false;
    for ix = 1:length(this.cells)
        if strcmp(this.cells(ix).name, name)
            cell = this.cells(ix);
            found = true;
            break;
        end
    end
    if ~found
        Error('Cell could not be found')
    end
    
    %------------- END OF CODE --------------
end