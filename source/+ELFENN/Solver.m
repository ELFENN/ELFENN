classdef Solver
    %Solver - ELFENN.Solver class
    %capacitance, network, odeHandle, nDynamicVariables, sigma, save_resolution
    % Inputs:
    %    capacitance       - Capcitance of each segment (scalar or double array)
    %    network           - Completed network (ELFENN.Network)
    %    odeHandle         - ODE right-hand side (handle)
    %    nDynamicVariables - Number of classical variables in segment (integer)
    %    sigma             - Extracellular conductivity
    %    save_resolution   - Time resolution to save points at
    %
    % Outputs:
    %    None
    %
    % Example:
    %    Assuming you already have a network named exampleNetwork, if you do
    %    not please see ELFENN.Network. For mode details about the
    %    function handles. Please see the quickstart guide. This class
    %    should never be manually constructed. Please use ELFENN.Supervisor
    %    to create it.
    %
    %    nDynamicVariables = 4;
    %    sigma = 0.05;
    %    capacitance = 1;
    %    resolution = 0.05
    %    solver = ELFENN.Solver(capacitance, network, ode_handle,...
    %             nDynamicVariables, conductivity, resolution);
    %
    % see also ELFENN.Network ELFENN.Supervisor
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    properties
        tmax = 100;
        iInjectedHandle;
        iMembraneHandle;
        nDynamicVariables;
        extra_electrodeCurrentHandle;
        point_synapseHandle
        rtol = 1e-4;
        maxStep = 0.05;
        IC;
        odeHandle;
        classicIndex;
        variableNames;
        ephapticStatus = 1;
        network;
        log_lookup_on_new_basis;
        electrode_scaling;
        recorders;
        recorderMap;
        sigma;
        FD;
        gapFD;
        capacitance;
        eventtimes;
        hasExternalSynapses = 0;
        hasChemicalSynapses = 0;
        hasIntracellularElectrodes = 0;
        hasExtracellularPlates = 0;
        hasExtracellularElectrodes = 0;
        plate_scaling
        plate_handle;
        save_resolution = 0.05;
        transientLength = 0;
        debug = 0;
    end
    methods
        function this = Solver(capacitance, network, odeHandle, nDynamicVariables, sigma, save_resolution)
            p = inputParser;
            p.addRequired('capacitance', @(x) validateattributes(x, {'numeric'}, {'positive'}));
            p.addRequired('network', @(x) validateattributes(x, {'ELFENN.Network'}, {}));
            nInCorrect = (nargin(odeHandle) == 2);
            p.addRequired('odeHandle', @(x) all([isa(x, 'function_handle'), nInCorrect]));
            p.addRequired('nDynamicVariables', @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar', 'integer'}));
            p.addRequired('sigma', @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));
            p.addRequired('save_resolution', @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));

            p.parse(capacitance, network, odeHandle, nDynamicVariables, sigma, save_resolution);
            
            nTotalSeg = network.nTotalSeg;           
            this.capacitance = capacitance;
            this.network = network;
            this.iInjectedHandle = @(t, y)network.icelltotalcurrent(t, y, nTotalSeg);
            this.extra_electrodeCurrentHandle = @(t, y) network.ecelltotalcurrent(t, y);
            this.point_synapseHandle = @(t, y) network.synapsetotalcurrent(t, y, nTotalSeg);
            this.plate_handle = @(t, y) network.platetotalcurrent(t, y);
            this.odeHandle = odeHandle;
            this.nDynamicVariables = nDynamicVariables;
            this.sigma = sigma;
            this.save_resolution = save_resolution;
            
            if ~isempty(network.iCellElectrodeArray)
                this.hasIntracellularElectrodes = 1;
            end
            
            if (~isempty(network.externalSynapseArray)) || (~isempty(network.chemicalSynapseArray))
                this.hasExternalSynapses = 1;
            end
            
            if ~isempty(network.chemicalSynapseArray)
                this.hasChemicalSynapses = 1;
            end
            
            if ~isempty(network.eCellElectrodeArray)
                this.hasExtracellularElectrodes = 1;
            end
                        
            if ~isempty(network.plateArray)
                this.hasExtracellularPlates = 1;
            end
            
            [this.recorders, this.recorderMap] = network.getrecordersandmap();
            this.log_lookup_on_new_basis = computeLFPfeatures(network, this.recorders);
            this.electrode_scaling = computeElectrodeFeatures(network, this.recorders);
            this.plate_scaling = computePlateFeatures(network, this.recorders);
            
            this.FD = network.resistivefdm;
            this.gapFD = network.gapjunctionfdm;
            
            
        end
        function this = set.maxStep(this, maxStep)
            this.maxStep = maxStep;
        end
        
        function this = set.rtol(this, rtol)
            this.rtol = rtol;
        end
        
        function this = set.tmax(this, tmax)
            this.tmax = tmax;
        end
        
        function this = set.ephapticStatus(this, ephapticStatus)           
            if strcmp(ephapticStatus, 'on')
                this.ephapticStatus = 1;
            else
                this.ephapticStatus = 0;
            end
        end
        
        function this = set.IC(this, userIC)
            p = inputParser;
            p.addRequired('userIC', @(x) validateattributes(x, {'numeric'}));
            
            if length(userIC) == (this.nDynamicVariables + 1) * this.network.nTotalSeg
                this.IC = userIC;
                totalDynamicVariables = this.nDynamicVariables + 1;
                
                CI = repmat(2:(totalDynamicVariables - 1), this.network.nTotalSeg, 1);
                CI = CI + (0:totalDynamicVariables:(totalDynamicVariables * (this.network.nTotalSeg - 1)))';
                this.classicIndex = reshape(CI', numel(CI), 1);
            else
                nNodes = length(userIC) / this.nDynamicVariables;
                totalDynamicVariables = this.nDynamicVariables + 1;
                icPlaceHolder = zeros(nNodes*totalDynamicVariables, 1);
                icPlaceHolder(2:totalDynamicVariables:end) = userIC(1:this.nDynamicVariables:end); %Vm
                classicIndexHolder = zeros(length(userIC), 1);
                classicIndexHolder(1:nNodes) = 2:totalDynamicVariables:length(icPlaceHolder);
                for ix = 2:this.nDynamicVariables
                    icPlaceHolder(ix+1:totalDynamicVariables:end) = userIC(ix:this.nDynamicVariables:end);
                    classicIndexHolder((ix - 1)*nNodes+1:ix*nNodes) = ix + 1:totalDynamicVariables:length(icPlaceHolder);
                end
                
                this.IC = icPlaceHolder;
                
                
                this.classicIndex = sort(classicIndexHolder);
              
                % try to compute consistent DAE solutions
                corrector = this.dYdt(0, this.IC);
                this.IC(1:this.nDynamicVariables+1:end) = ...
                    this.IC(1:this.nDynamicVariables+1:end) - ...
                    corrector(1:this.nDynamicVariables+1:end);                                
                
                this.IC(2:this.nDynamicVariables+1:end) = ...
                    this.IC(2:this.nDynamicVariables+1:end) + ...
                    corrector(1:this.nDynamicVariables+1:end);
            end
            
        end
        function [t, y] = run(this)
            %RUN - run solver and compute solution
            %
            % Inputs:
            %    nTotalSeg - Total number of segments (integer)
            %
            % Outputs:
            %    t - Time of each step (double array)
            %    y - Solution (double array)
            %
            % Example:
            %    [t, y] = solver.run()
            
            % Author: Aaron R. Shifman, John E. Lewis
            % Center for Neural Dynamics, University of Ottawa, Canada
            % Department of Biology, University of Ottawa, Canada
            % Brain and Mind Research Institute, University of Ottawa, Canada
            % email address: ashifman@uottawa.ca
            
            %------------- BEGIN CODE --------------
            
            if isempty(this.network.externalSynapseArray)
                this.eventtimes = [0, this.tmax];
            else
                this.eventtimes = sort(unique([this.network.externalSynapseArray.eventtimes]));
                this.eventtimes = this.eventtimes((this.eventtimes > 0) & (this.eventtimes < this.tmax));
                if this.eventtimes(1) ~= 0
                    this.eventtimes = [0, this.eventtimes];
                end
                
                if this.eventtimes(end) ~= this.tmax
                    this.eventtimes = [this.eventtimes, this.tmax];
                end
            end
            
            nTotalSeg = this.network.nTotalSeg;
            M = sparse(zeros(this.nDynamicVariables+1, this.nDynamicVariables+1));
            M(1, 1) = 0;
            M(2, 2) = 1;
            for ix = 2:this.nDynamicVariables
                M(ix+1, ix+1) = 1;
            end
            M = kron(eye(nTotalSeg), M);
            
            atol = 0.001 * ones(size(this.IC)); % all set to 0.001 (kept for m,n,h, types)
            atol(1:this.nDynamicVariables+1:end) = 0.1; % 100 uV for Vout
            atol(2:this.nDynamicVariables+1:end) = 0.01; % 5mV for Vm
            f = @(t, y) this.dYdt(t, y);
            
            if this.transientLength > 0
                old_rtol = this.rtol;
                this.rtol = 1;
                
                opts = odeset('AbsTol', atol, 'RelTol', this.rtol, 'MaxStep', ...
                    this.maxStep, 'Mass', M, 'masssingular', 'yes', 'normcontrol', 'off', 'InitialStep', this.save_resolution, ...
                    'BDF', 'bdf');
                                                
                old_status = this.ephapticStatus;
                
                this.ephapticStatus = 0;
                [~, y_trans] = ode15s(f, [0, this.transientLength], this.IC, opts);
                this.IC = y_trans(end, :)';
                this.ephapticStatus = old_status;
                this.rtol = old_rtol;
            end
            
            opts = odeset('AbsTol', atol, 'RelTol', this.rtol, 'MaxStep', ...
                this.maxStep, 'Mass', M, 'masssingular', 'yes', 'normcontrol', 'off', 'InitialStep', this.save_resolution, ...
                'BDF', 'bdf');
                        
            
            presynaptic_index = [];
            v_ix = [];
            if this.hasChemicalSynapses
                presynaptic_index = unique([this.network.chemicalSynapseArray.presyn]);
                v_ix = 2:this.nDynamicVariables + 1:size(this.IC, 1);
                v_ix = v_ix(presynaptic_index);
                opts = odeset(opts, 'Events', @(t, y)this.spike_event(t, y, v_ix));
            end
            
            tranges = [this.eventtimes(1:end-1)', this.eventtimes(2:end)'] + [1e-10, -1e-10];
            
            alltime = [];
            allsolution = [];
            ic = this.IC;
            for time_index = 1:size(tranges, 1)
                ts = tranges(time_index, :);
                start_time = ts(1);
                times = start_time:this.save_resolution:ts(2);
                while start_time < times(end)
                    if this.hasChemicalSynapses
                        [t, y, te, ~, ie] = ode15s(f, times, ic, opts);
                    else
                        
                        [t, y] = ode15s(f, times, ic, opts);
                        te = [];
                        ie = [];
                    end
                    alltime = [alltime; t];
                    allsolution = [allsolution; y];
                    start_time = t(end) + 1e-10;
                    times = start_time:this.save_resolution:ts(2);
                    
                    if this.hasChemicalSynapses
                        if ~isempty(ie) % update_synapses
                            for spike_ix = 1:length(ie)' % should be a scalar
                                for syn_ix = 1:length([this.network.chemicalSynapseArray.presyn])
                                    if this.network.chemicalSynapseArray(syn_ix).presyn == presynaptic_index(ie(spike_ix))
                                        this.network.chemicalSynapseArray(syn_ix).parameters.t0 = ...
                                            [this.network.chemicalSynapseArray(syn_ix).parameters.t0, te(spike_ix)];                                                                                
                                        
                                    end
                                end
                            end
                        end
                    end
                    
                    ic = y(end, :)';
                    
                    % update starting DAE solution with correct values
                    i_synapse = this.point_synapseHandle(start_time, y(end, 2:this.nDynamicVariables+1:end));
                    ic(1:this.nDynamicVariables+1:end) = ... .
                        ic(1:this.nDynamicVariables+1:end) + ...
                        this.voltage_from_current(ic(this.nDynamicVariables+1:this.nDynamicVariables+1:end)+i_synapse, ic);                                        
                    
                    if (time_index == size(tranges, 1)) && isempty(ie)
                        break
                    end
                end
            end
            
            t = alltime;
            y = allsolution;
                        
            %------------- END OF CODE --------------
        end
        
        function Vout = voltage_from_current(this, membraneCurrent, rhs)
            I_transmembrane = membraneCurrent - this.capacitance * rhs(2:this.nDynamicVariables+1:end); %%%    
            VoutAtRecorder = -1e3 * this.log_lookup_on_new_basis / (2 * this.sigma) * I_transmembrane / 100;  
                 
            Vout = cumsum(VoutAtRecorder);
            Vout = Vout([this.recorderMap(2:end, 1) - 1; this.recorderMap(end, 2)]);
            Vout = [Vout(1); diff(Vout)] ./ (1 + diff(this.recorderMap, 1, 2)); % MAGIC TRICK
        end
        
        function rhs = dYdt(this, t, y)
            if this.debug
                disp(t)
            end
            rhs = zeros(size(y));
            classicVariables = y(this.classicIndex);
            if this.hasIntracellularElectrodes
                injectedCurrent = this.iInjectedHandle(t, classicVariables);
            else
                injectedCurrent = 0;
            end
            
            if this.hasExternalSynapses
                synapticCurrent = this.point_synapseHandle(t, classicVariables(1:this.nDynamicVariables:end)) / 100;
            else
                synapticCurrent = 0;
            end
            
            Vm = y(2:this.nDynamicVariables+1:end);
            Vout = y(1:this.nDynamicVariables+1:end);
            Vin = Vm + Vout * this.ephapticStatus;
            
            axialCurrent = this.FD * Vin + this.gapFD * Vm;
            
            if isempty(axialCurrent)
                axialCurrent = 0;
            end
            
            dYdtClassic = this.odeHandle(t, classicVariables);
            membraneCurrent = dYdtClassic(1:this.nDynamicVariables:end) + synapticCurrent;
            
            %Vm
            rhs(2:this.nDynamicVariables+1:end) = membraneCurrent + ...
                (injectedCurrent + axialCurrent) / this.capacitance;
                                    
            Vout = this.voltage_from_current(membraneCurrent, rhs);
            
            
            % ELECTRODE
            if this.hasExtracellularElectrodes
                electrodeCurrent = this.extra_electrodeCurrentHandle(t, classicVariables);
                I_electrode = electrodeCurrent; % col
                
                if ~isempty(this.electrode_scaling)
                    V_electrode_contribution = repmat(I_electrode', length(this.electrode_scaling), 1) .* this.electrode_scaling / (this.sigma);
                    V_electrode_at_recorder = 1e3 * sum(V_electrode_contribution, 2);
                    V_electrode = cumsum(V_electrode_at_recorder);
                    V_electrode = V_electrode([this.recorderMap(2:end, 1) - 1; this.recorderMap(end, 2)]);
                    V_electrode = [V_electrode(1); diff(V_electrode)] ./ (1 + diff(this.recorderMap, 1, 2)); % MAGIC TRICK
                    
                    Vout = Vout + V_electrode; % ELECTRODES HERE;
                    
                end
            end
            
            %plates
            if this.hasExtracellularPlates
                electrodeCurrent = this.plate_handle(t, classicVariables);
                I_electrode = electrodeCurrent; % col
                
                if ~isempty(this.plate_scaling)
                    V_electrode_contribution = repmat(I_electrode', length(this.plate_scaling), 1) .* this.plate_scaling;
                    V_electrode_at_recorder = sum(V_electrode_contribution, 2);
                    V_electrode = cumsum(V_electrode_at_recorder);
                    V_electrode = V_electrode([this.recorderMap(2:end, 1) - 1; this.recorderMap(end, 2)]);
                    V_electrode = [V_electrode(1); diff(V_electrode)] ./ (1 + diff(this.recorderMap, 1, 2)); % MAGIC TRICK
                    
                    Vout = Vout + V_electrode; % ELECTRODES HERE;
                    
                end
            end
            
            
            % Vout
            rhs(1:this.nDynamicVariables+1:end) = y(1:this.nDynamicVariables+1:end) - Vout; %Vout.*(Vout>1e-3 ); % Vout = 0;

            for ix = 2:this.nDynamicVariables % Classical
                rhs(ix+1:this.nDynamicVariables+1:end) = dYdtClassic(ix:this.nDynamicVariables:end);
            end
            
        end
        
        function I_trans = reconstruct_I_trans(this, ts, ys)
            I_trans = zeros(length(ts), size(ys, 2)/(this.nDynamicVariables + 1));
            for ix = 1:length(ts)
                I_trans(ix, :) = -this.reconstruct_I_trans_t(ts(ix), ys(ix, :)');
            end
        end
        function I_trans = reconstruct_I_trans_t(this, t, y)
            classicVariables = y(this.classicIndex);
            if this.hasIntracellularElectrodes
                injectedCurrent = this.iInjectedHandle(t, classicVariables);
            else
                injectedCurrent = 0;
            end
            
            if this.hasExternalSynapses
                synapticCurrent = this.point_synapseHandle(t, classicVariables(1:this.nDynamicVariables:end)) / 100;
            else
                synapticCurrent = 0;
            end
            Vm = y(2:this.nDynamicVariables+1:end);
            Vout = y(1:this.nDynamicVariables+1:end);
            Vin = Vm + Vout * this.ephapticStatus; %y(1:this.nDynamicVariables+3:end);
            
            axialCurrent = this.FD * Vin + this.gapFD * Vm;
            
            if isempty(axialCurrent)
                axialCurrent = [0];
            end
            
            dYdtClassic = this.odeHandle(t, classicVariables);
            membraneCurrent = dYdtClassic(1:this.nDynamicVariables:end);
            
            %Vm
            rhs = dYdtClassic(1:this.nDynamicVariables:end) + ...
                (injectedCurrent + axialCurrent + synapticCurrent) / this.capacitance;
            
            
            
            I_trans = membraneCurrent - this.capacitance * rhs; %%%
        end
    end
    
    methods(Static)
        function [value, isterminal, direction] = spike_event(t, y, v_ix)
            v = y(v_ix);
            value = double(v >= 20);
            isterminal = ones(size(v));
            direction = ones(size(v)); % increaseing
        end
    end
    
    %------------- END OF CODE --------------
end
