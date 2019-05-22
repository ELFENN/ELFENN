function addextracellularelectrode(this, position, f, parameters)
    %ADDEXTRACELLULARELECTRODE - Extracellular stimulation electrode
    %Add an electrode current source to the extracellular space
    %
    % Inputs:
    %    position   - (x,y,z) coordinates of electrode (numeric array)
    %    f          - Current function has the signature f(t, y, parameters) (function handle)
    %    parameters - Structure of parameters for current function (struct)
    %
    % Outputs:
    %    None
    %
    % Raises:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network.
    %
    %    f = somefunction;
    %    p = someparams;
    %    exampleNetwork.addextracellularelectrode(testNetwork.cells(1).tip, f, p)
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('position', @(x) validateattributes(x, {'numeric'}, {'size', [1, 3]}));
    nInCorrect = (nargin(f) == 3);
    p.addRequired('f', @(x) all([isa(x, 'function_handle'), nInCorrect]));
    p.addRequired('parameters');
    p.parse(position, f, parameters);
    
    parameters.amp = parameters.amp * 1e-9;
    
    extracellularCurrent = @(t, y) f(t, y, parameters);
    e = ELFENN.Mechanisms.Stimulus.Electrode(position, extracellularCurrent);
    this.eCellElectrodeArray = [this.eCellElectrodeArray, e];
    
    %------------- END OF CODE --------------
end