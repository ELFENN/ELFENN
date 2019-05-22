function runHH_Two_Cell(configuration)
    % Config settings
    axonLength = configuration.L_axon;
    somaLength = configuration.L_soma;
    axonRadius = configuration.diam_axon / 2;
    somaRadius = configuration.diam_soma / 2;
    Ra = configuration.Ra;
    axonNSeg = configuration.nseg_axon;
    somaNSeg = configuration.nseg_soma;
    injectedAmpAxon = configuration.amp_axon;
    injectedAmpSoma = configuration.amp_soma;
    saveName = configuration.save_name;
    tmax = configuration.sim_length;
    
    % Construction
    soma = ELFENN.Section('soma', 'radius', somaRadius, 'sectionLength', somaLength, ...
        'nSeg', somaNSeg, 'sectionGeometry', 'S', 'nAxes', 3, 'isNEURON', true);
    
    
    
    axon = ELFENN.Section('axon', 'radius', axonRadius, 'sectionLength', axonLength, ...
        'nSeg', axonNSeg, 'sectionGeometry', 'C', 'nAxes', 2);
    
    
    
    cell = ELFENN.Cell('cell1');
    cell.connectsection(soma, axon, [0, 0, 0]);
    cell.rotateoffsoma(cell.getsectionbyname('soma').name);
    network = ELFENN.Network();
    network.addcell(cell, [0, 0, 0]);
    cell.name = 'cell2';
    network.addcell(cell, [0, 0, 200]);
    network.complete()
    
    
    % Simulation
    injectedParameters.amp = injectedAmpSoma;
    network.addintracellularelectrode(network.getcellbyname('cell1').soma, @ELFENN.Mechanisms.Stimulus.dc_stimulus, injectedParameters, 'unscaled')
    injectedParameters.amp = injectedAmpAxon;
    network.addintracellularelectrode(network.getcellbyname('cell2').getsectionbyname('axon').mid, @ELFENN.Mechanisms.Stimulus.dc_stimulus, injectedParameters, 'unscaled')
    
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
    Vm_index = network.getnamedsolutionindex('Vm', ...
        [string('cell1'), string('cell2'), string('cell1'), string('cell2')], ...
        [{'soma'}, {'soma'}, {'axon'}, {'axon'}]);
    
    
    
    csvwrite([saveName, '.csv'], [t, y(:, Vm_index)]);
end