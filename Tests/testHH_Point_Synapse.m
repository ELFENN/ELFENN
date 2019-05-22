classdef testHH_Point_Synapse < matlab.unittest.TestCase
    properties(TestParameter)
        filenames = {'single', 'multi', 'multiple_spikes'};
    end
    methods(Test)
        function testHH_Point_Synapse_Neuron(testCase, filenames)
            NEURON_error(testCase, filenames, 'HH_Point_Synapse');
        end
    end
end