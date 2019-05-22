function membraneParameters = default_parameters()
    
    membraneParameters = struct();
    membraneParameters.ENa = 50; %mV
    membraneParameters.EK = -90; %mV
    membraneParameters.EL = -70; %mV
    
    membraneParameters.gNa = 112.5; %mS/cm^2
    membraneParameters.gK_v3 = 225; %mS/cm^2
    membraneParameters.gK_v1 = 0.225; %mS/cm^2
    membraneParameters.gL = 0.25; %mS/cm^2
    
    membraneParameters.C = 1; %uF/cm^2
    
end
