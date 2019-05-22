function LFPy_error(testCase, fileName, folderName)
    
    neuronFiles = dir([folderName, '/NEURON_Results/', fileName, '_LFP.mat']);
    neuronData = [neuronFiles(1).folder, '/', neuronFiles(1).name];
    matlabData = [neuronFiles(1).folder, '/../MATLAB_Results/', neuronFiles(1).name];
    
    neuron = load(neuronData);
    matlab = load(matlabData);
    
    
    [t_ix_matlab, t_ix_neuron] = interp_time_ix(matlab, neuron);
    
    
    y_values = unique(matlab.y_elec);
    
    nrmses = zeros(size(neuron.LFP, 1), 1);
    for version = 1:size(neuron.LFP, 1)
        y_ix_matlab = matlab.y_elec == y_values(version);
        LFP_matlab = matlab.Vout(t_ix_matlab, y_ix_matlab);
        
        LFP_neuron = squeeze(neuron.LFP(version, :, :));
        LFP_neuron = rot90(LFP_neuron);
        LFP_neuron = flipud(LFP_neuron);
        LFP_neuron = LFP_neuron(t_ix_neuron, :);
        
        error = LFP_matlab - LFP_neuron;
        error = sqrt(mean(error(:).^2));
        
        nrmses(version) = error / (max(LFP_neuron(:)) - min(LFP_neuron(:)));
        
    end
    testCase.verifyLessThan(mean(nrmses), 0.2); % 2% error;
end