function synapseParameters = default_parameters()
    
    synapseParameters = struct();
    synapseParameters.ESyn = 0; %mV
    synapseParameters.gSyn = 100; %mS/cm^2
    synapseParameters.tau = 5; %ms
    synapseParameters.t0 = [20, 50];
    
end
