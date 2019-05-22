function NEURON_error(testCase, fileName, folderName)
    neuronFiles = dir([folderName, '/NEURON_Results/', fileName, '.csv']);
    
    neuronData = [neuronFiles(1).folder, '/', neuronFiles(1).name];
    matlabData = [neuronFiles(1).folder, '/../MATLAB_Results/', neuronFiles(1).name];
    
    neuronData = csvread(neuronData);
    matlabData = csvread(matlabData);
    
    tNeuron = neuronData(:, 1);
    neuronData = neuronData(:, 2:end);
    
    tMatlab = matlabData(:, 1);
    matlabData = matlabData(:, 2:end);
    
    deltaT = 0.01;
    tInterp = 0:deltaT:tNeuron(end) + deltaT;
    
    neuronData = interp1(tNeuron, neuronData, tInterp, 'linear', 'extrap');
    ix_v = find(tMatlab(2:end) ~= tMatlab(1:end-1));
    matlabData = interp1(tMatlab(ix_v), matlabData(ix_v, :), tInterp, 'linear', 'extrap');
    
    error = abs(neuronData-matlabData);
    rms = sqrt(mean(error.^2));
    testCase.verifyLessThan(max(rms), 5); % 4mV RMS error;
end