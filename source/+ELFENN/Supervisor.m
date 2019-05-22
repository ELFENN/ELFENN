function [solver] = Supervisor(ode, network, ic, conductivity, varargin) % spec
    %SUPERVISOR - Generate a solver object based on the network
    % Compute initial conditions, check the ODE, create the solver object.
    %
    % Inputs:
    %    ode          - ODE function (function handle)
    %    network      - Network object (ELFENN.Network)
    %    ic           - Initial conditions (numeric array)
    %    conductivity - Extracellular conductivity (numeric)
    %    spec         - Are initial conditions specified as uniform or exact (optional) (boolean: 0/1)
    %    resolution   - Save time resolution (dt of saved points) (numeric) optional
    %
    % Outputs:
    %    Solver - (ELFENN.Solver)
    %
    % Raises:
    %    Error: Number of initial conditions does not match ODE dimension
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network.
    %
    %    f = someFunction;
    %    IC = [0,0,0,0];
    %    conductivity = 0.05;
    %    spec = 0;
    %    r = 0.05; % ms
    %    solver = Supervisor(f, exampleNetwork, IC, conductivity, spec, ...
    %    'resolution, resolution);
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    p = inputParser;
    nInCorrect = (nargin(ode) == 3);
    p.addRequired('ode', @(x) all([isa(x, 'function_handle'), nInCorrect]));
    p.addRequired('network', @(x) validateattributes(x, {'ELFENN.Network'}, {}));
    p.addRequired('ic', @(x) validateattributes(x, {'numeric'}, {}));
    p.addRequired('conductivity', @(x) validateattributes(x, {'numeric'}, {'positive', 'nonempty'}));
    p.addOptional('spec', 0, @(x) (x == 0) || (x == 1));
    p.addParameter('resolution', 0.05, @(x) validateattributes(x, {'numeric'}, {'positive', 'nonempty'}));
    p.parse(ode, network, ic, conductivity, varargin{:});
    
    spec = p.Results.spec;
    saveResolution = p.Results.resolution;
    
    parameterNames = fields(network.cells(1).sections(1).dynamicsParameters);
    p_m = zeros(network.nTotalSeg, length(parameterNames));
    
    for c = network.cells
        for s = c.sections
            for p = 1:length(parameterNames)
                p_m([s.segments.connectivityid], p) = s.dynamicsParameters.(cell2mat(parameterNames(p)));
            end
        end
    end
    
    params = struct();
    for p = 1:length(parameterNames)
        if length(unique(p_m(:, p))) == 1
            params.(cell2mat(parameterNames(p))) = unique(p_m(:, p));
        else
            params.(cell2mat(parameterNames(p))) = p_m(:, p);
        end
    end
    
    odeHandle = @(t, x) ode(t, x, params);
    
    if spec
        nDimension = length(ic) / network.nTotalSeg - 1; % TODO: check?
    else
        nDimension = length(ic);
        
        flagged = 0;
        try
            odeHandle(0, (1:nDimension * network.nTotalSeg)');
        catch
            flagged = 1;
        end
        
        if flagged
            error('Number of initial conditions does not match ODE');
        end
        
        expandedIC = zeros(network.nTotalSeg*nDimension, 1);
        for ix = 1:nDimension
            expandedIC(ix:nDimension:end) = ic(ix);
        end
        ic = expandedIC;
    end
    
    solver = ELFENN.Solver(params.C, network, odeHandle, nDimension, conductivity, saveResolution);
    solver.IC = ic;
end