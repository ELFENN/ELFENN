classdef test_gap_junction < matlab.unittest.TestCase
    methods(Static)
        function [network, networkGap] = generate_both()
            cell = ELFENN.Cell('cell1');
            section1 = ELFENN.Section('axon', 'nSeg', 3, 'sectionLength', 100, 'Ra', 3500, 'radius', 0.5);
            section2 = ELFENN.Section('axon2', 'nSeg', 1, 'sectionLength', 100/3, 'Ra', 3500, 'radius', 0.5);
            cell.connectsection(section1, section2);
            network = ELFENN.Network();
            network.addcell(cell, [0, 0, 0]);
            network.complete();
            
            cell = ELFENN.Cell('cell1');
            section1 = ELFENN.Section('axon', 'nSeg', 3, 'sectionLength', 100, 'Ra', 3500, 'radius', 0.5);
            section2 = ELFENN.Section('axon2', 'nSeg', 1, 'sectionLength', 100/3, 'Ra', 3500, 'radius', 0.5);
            cell.connectsection(section1);
            cell2 = ELFENN.Cell('cell2');
            cell2.connectsection(section2);
            networkGap = ELFENN.Network();
            networkGap.addcell(cell, [0, 0, 0]);
            networkGap.addcell(cell2, [0, 100, 0]);
            networkGap.complete();
        end
    end
    methods(Test)
        %         function test_connectivity(testCase) DEPRECATED AS GAP IN NEW
        %         FORMAT
        %             injectedParameters.injectedSegment = 1;
        %             injectedParameters.amp = 0.02;
        %
        %             [network, networkGap] = test_gap_junction.generate_both();
        %             network.addintracellularelectrode(network.cells(1).tip, @ELFENN.Mechanisms.Stimulus.dc_stimulus, injectedParameters, 'unscaled')
        %             networkGap.addintracellularelectrode(networkGap.cells(1).tip, @ELFENN.Mechanisms.Stimulus.dc_stimulus, injectedParameters, 'unscaled')
        %
        %             fd1 = network.resistivefdm;
        %             fd2 = networkGap.resistivefdm;
        %             resistance = full(network.resistivefdm(3,4))*(network.cells(1).sections(2).segmentArea*1e-4*1e-4);
        %             networkGap.addelectricalsynapse(3, 4, resistance);
        %
        %             err_conn = fd1 - fd2;
        %             testCase.verifyLessThan(sum(err_conn(:)), 1e-15);
        %         end
        function gap_junctions(testCase)
            injectedParameters.injectedSegment = 1;
            injectedParameters.amp = 0.02;
            
            [network, networkGap] = test_gap_junction.generate_both();
            network.addintracellularelectrode(network.cells(1).tip, @ELFENN.Mechanisms.Stimulus.dc_stimulus, injectedParameters, 'unscaled')
            networkGap.addintracellularelectrode(networkGap.cells(1).tip, @ELFENN.Mechanisms.Stimulus.dc_stimulus, injectedParameters, 'unscaled')
            
            resistance = full(network.resistivefdm(3, 4)) * (network.cells(1).sections(2).segmentArea * 1e-4 * 1e-4);
            networkGap.addelectricalsynapse(3, 4, resistance);
            
            IC = [-64.98, 0.05309, 0.6, 0.318]; % IC IS EITHER UNIFORM OF CONTAIN EPHAPTIC IC
            
            network.setdynamics(ELFENN.Mechanisms.Cellular.HH.default_parameters())
            solver = ELFENN.Supervisor(@ELFENN.Mechanisms.Cellular.HH.ode, network, IC, 0.05);
            solver.tmax = 30;
            solver.ephapticStatus = 'off';
            [t_full, y_full] = solver.run();
            
            networkGap.setdynamics(ELFENN.Mechanisms.Cellular.HH.default_parameters())
            solver = ELFENN.Supervisor(@ELFENN.Mechanisms.Cellular.HH.ode, networkGap, IC, 0.05);
            solver.tmax = 30;
            solver.ephapticStatus = 'off';
            [t_gap, y_gap] = solver.run();
            
            minmax_t = min(t_gap(end), t_full(end));
            t_int = 1:0.05:minmax_t; % slight timing differences;
            
            v_full = y_full(:, 2:5:end);
            v_gap = y_gap(:, 2:5:end);
            v_gap = interp1(t_gap, v_gap, t_int');
            v_full = interp1(t_full, v_full, t_int');
            
            err_values = v_full - v_gap;
            err_values = sqrt(mean(err_values.^2)) / range(v_full);
            
            testCase.verifyLessThan(err_values, 1e-3);
        end
    end
end