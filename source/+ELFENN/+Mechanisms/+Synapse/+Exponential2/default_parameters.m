function synapseParameters = default_parameters()
    
    synapseParameters = struct();
    synapseParameters.ESyn = 0; %mV
    synapseParameters.gSyn = 100; %mS/cm^2
    synapseParameters.rise = 2; %ms rise
    synapseParameters.decay = 10; %ms fall
    synapseParameters.t0 = [20, 70];
    
end
