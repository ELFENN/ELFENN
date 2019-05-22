function membraneParameters = default_parameters()
    
    membraneParameters = struct();
    membraneParameters.ENa = 50; %mV
    membraneParameters.EK = -77; %mV
    membraneParameters.EL = -54.3; %mV
    
    membraneParameters.gNa = 120; %mS/cm^2
    membraneParameters.gK = 36; %mS/cm^2
    membraneParameters.gL = 0.3; %mS/cm^2
    
    membraneParameters.C = 1; %uF/cm^2
    
end
