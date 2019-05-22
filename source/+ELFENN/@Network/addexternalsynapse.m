function addexternalsynapse(this, position, f, parameters, varargin)
    %ADDEXTERNALSYNAPSE - Add a chemical synapse
    %Add an non-autonomous (synapse with pre-defined spike times) between two
    %compartments
    %
    % Inputs:
    %    position   - Index to add electrode to (integer)
    %    f          - Current function has the signature f(t, parameters) (function handle)
    %    parameters - Structure of parameters for current function (struct)
    %    scaling    - If set to 'unscaled' the units are uS, if unspecified or 'scaled' units are mS/cm^2 (String) (optional)
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
    %    exampleNetwork.addpointsynapse(testNetwork.cells(1).tip, f, p)
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    p.addRequired('position', @(x) validateattributes(x, {'numeric'}, ...
        {'positive', 'nonempty', 'integer'}));
    
    
    
    nInCorrect = (nargin(f) == 2);
    p.addRequired('f', @(x) all([isa(x, 'function_handle'), nInCorrect]));
    p.addRequired('parameters');
    p.addOptional('scaling', 'scaled', @(x) any(strcmp(x, {'scaled', 'unscaled'})));
    p.parse(position, f, parameters, varargin{:});
    scaling = p.Results.scaling;
    
    if ~strcmp(scaling, 'scaled') % not scaled => uS, scaled => mS/cm^2
        parentSection = this.sectionsearchbyseg(position);
        parameters.gSyn = 1e-3 * parameters.gSyn / (parentSection.segmentArea * 1e-4 * 1e-4);
    end
    
    parameters.t0 = parameters.t0(:)';
    synapticCurrent = @(t, v) - parameters.gSyn .* f(t, parameters) .* (v - parameters.ESyn);
    e = ELFENN.Mechanisms.Synapse.PointSynapse(position, synapticCurrent, parameters.t0);
    this.externalSynapseArray = [this.externalSynapseArray, e];
    
    %------------- END OF CODE --------------
end