classdef test_extracell < matlab.unittest.TestCase
    properties(TestParameter)
        amp = {0, -1, 15};
    end
    methods(Test)
        function test_single_comp(testCase, amp)
            
            distance = 50;
            cell = ELFENN.Cell('cell1');
            section1 = ELFENN.Section('axon', 'nSeg', 1, 'sectionLength', 100, 'Ra', 3500, 'radius', 0.5);
            cell.connectsection(section1);
            network = ELFENN.Network();
            network.addcell(cell, [0, 0, 0]);
            network.complete();
            
            stim_params.amp = amp;
            network.addextracellularelectrode([50, 50, 0], @ELFENN.Mechanisms.Stimulus.dc_stimulus, stim_params);
            
            IC = [-64.98, 0.05309, 0.6, 0.318]; % IC IS EITHER UNIFORM OF CONTAIN EPHAPTIC IC
            
            network.setdynamics(ELFENN.Mechanisms.Cellular.HH.default_parameters())
            solver = ELFENN.Supervisor(@ELFENN.Mechanisms.Cellular.HH.ode, network, IC, 0.005);
            solver.tmax = 30;
            solver.ephapticStatus = 'off';
            [t, y] = solver.run();
            
            Vout = y(end, 1);
            
            true = 1e3 * stim_params.amp * 1e-9 / (4 * pi * 0.005 * distance * 1e-6);
            if true == 0
                testCase.verifyLessThan(Vout, 1e-3); % < 1uV
            else
                testCase.verifyLessThan(abs(Vout-true)/true, 1e-3); % < 0.01%
            end
        end
    end
end