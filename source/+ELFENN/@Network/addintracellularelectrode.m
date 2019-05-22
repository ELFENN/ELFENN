function addintracellularelectrode(this, position, f, parameters, varargin)
    %ADDINTRACELLULARELECTRODE - Inject current at a point
    %Add an injected current source at a point in the cell
    %
    % Inputs:
    %    position   - Index to add electrode to (integer)
    %    f          - Current function has the signature f(t, y, parameters) (function handle)
    %    parameters - Structure of parameters for current function (struct)
    %    scaling    - If set to 'unscaled' the units are nA if unspecified or 'scaled' units are mA/cm^2 (String) (optional)
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
    %    exampleNetwork.addintracellularelectrode(testNetwork.cells(1).tip, f, p, 'unscaled')
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    
    p = inputParser;
    p.addRequired('position', @(x) validateattributes(x, {'numeric'}, {'positive', 'nonempty', 'integer'}));
    nInCorrect = (nargin(f) == 3);
    p.addRequired('f', @(x) all([isa(x, 'function_handle'), nInCorrect]));
    p.addRequired('parameters');
    p.addOptional('scaling', 'scaled', @(x) any(strcmp(x, {'scaled', 'unscaled'})));
    p.parse(position, f, parameters, varargin{:});
    scaling = p.Results.scaling;
    
    if ~strcmp(scaling, 'scaled') % not scaled => nA, scaled => uA/cm^2
        parentSection = this.sectionsearchbyseg(position);
        parameters.amp = 1e-3 * parameters.amp / (parentSection.segmentArea * 1e-4 * 1e-4);
    end
    
    electrodeCurrent = @(t, y) f(t, y, parameters);
    e = ELFENN.Mechanisms.Stimulus.Electrode(position, electrodeCurrent);
    this.iCellElectrodeArray = [this.iCellElectrodeArray, e];
    
    %------------- END OF CODE --------------
end