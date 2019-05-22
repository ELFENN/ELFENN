function runHH_Soma_Axon(configuration)
    % Config settings
    axonLength = configuration.L_axon;
    somaLength = configuration.L_soma;
    axonRadius = configuration.diam_axon / 2;
    somaRadius = configuration.diam_soma / 2;
    Ra = configuration.Ra;
    axonNSeg = configuration.nseg_axon;
    somaNSeg = configuration.nseg_soma;
    injectedAmp = configuration.amp;
    saveName = configuration.save_name;
    tmax = configuration.sim_length;
    
    % Construction
    cell = ELFENN.Cell('cell1');
    soma = ELFENN.Section('soma', 'nSeg', somaNSeg, 'sectionLength', somaLength, 'Ra', ...
        Ra, 'radius', somaRadius, 'sectionGeometry', 'S', 'isNEURON', true);
    
    
    
    axon = ELFENN.Section('axon', 'nSeg', axonNSeg, 'sectionLength', axonLength, 'Ra', Ra, 'radius', axonRadius);
    cell.connectsection(soma, axon, [0, 0, 0]);
    network = ELFENN.Network();
    network.addcell(cell, [0, 0, 0]);
    network.complete()
    
    % Simulation
    injectedParameters.amp = injectedAmp;
    network.addintracellularelectrode(network.getcellbyname('cell1').soma, @ELFENN.Mechanisms.Stimulus.dc_stimulus, injectedParameters, 'unscaled')
    
    IC = [-64.974597972708651, 0.053091060286233, ...
        0.594063768482307, 0.318032413734906];
    
    
    
    network.setdynamics(ELFENN.Mechanisms.Cellular.HH.default_parameters())
    solver = ELFENN.Supervisor(@ELFENN.Mechanisms.Cellular.HH.ode, network, IC, 0.05);
    
    solver.ephapticStatus = 'off';
    solver.tmax = tmax;
    solver.rtol = 1e-5;
    [t, y] = solver.run();
    
    % Saving data
    network.assignsolutionindex('Vm', 'm', 'h', 'n')
    Vm_index = network.getallnamedsolutionindex('Vm');
    csvwrite([saveName, '.csv'], [t, y(:, Vm_index)]);
    
    %Im_index = network.getallnamedsolutionindex('Im');
    positionToCalculateX = somaLength:1:1.2 * axonLength;
    positionToCalculateY = [1, 1.5, 2];
    positionToCalculateZ = 0;
    
    [XX, YY, ZZ] = meshgrid(positionToCalculateX, positionToCalculateY, positionToCalculateZ);
    x_elec = XX(:);
    y_elec = YY(:);
    z_elec = ZZ(:);
    sigma = 0.05;
    Im = solver.reconstruct_I_trans(t, y);
    Vout = calculatelfp_PH(network, Im, XX, YY, ZZ, sigma);
    save([saveName, '_LFP'], 'Vout', 'x_elec', 'y_elec', 'z_elec', 't')
end