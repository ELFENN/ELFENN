function addextracellularplate(this, point, plane, sep, f, parameters)
    %ADDEXTRACELLULARPLATE - Add parallel plate electrodes
    % Adds a uniform electric field with constant field strength to the
    % extracellular space. Electrodes must be placed outside the range of all
    % cells and care should be taken as the definition of electrical 0 becomes
    % poorly defined. Point/line sources have ground at infinity superimposed
    % with a floating field
    %
    % Inputs:
    %    point      - (x,y,z) coordinates of point on first plate (numeric array)
    %    plane      - Normal vector to the plate (numeric array)
    %    sep        - Distance between plates (numeric)
    %    f          - Electric field function f(t, y, parameters) (function handle)
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
    p.addRequired('point', @(x) validateattributes(x, {'numeric'}, {'size', [1, 3]}));
    p.addRequired('plane', @(x) validateattributes(x, {'numeric'}, {'size', [1, 3]}));
    p.addRequired('sep', @(x) validateattributes(x, {'numeric'}, {'positive', 'nonempty'}));
    nInCorrect = (nargin(f) == 3);
    p.addRequired('f', @(x) all([isa(x, 'function_handle'), nInCorrect]));
    p.addRequired('parameters');
    p.parse(point, plane, sep, f, parameters);
    
    electricField = @(t, y) f(t, y, parameters);
    e = ELFENN.Mechanisms.Stimulus.ExtracellularPlates(point, plane, sep, electricField);
    this.plateArray = [this.plateArray, e];
    
    %------------- END OF CODE --------------
end