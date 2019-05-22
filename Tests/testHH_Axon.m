classdef testHH_Axon < matlab.unittest.TestCase
    properties(TestParameter)
        filenames = {'single', 'short', 'long'};
    end
    methods(Test)
        function testHH_Axon_NEURON(testCase, filenames)
            NEURON_error(testCase, filenames, 'HH_Axon');
        end
        function testHH_Axon_LFP(testCase, filenames)
            LFPy_error(testCase, filenames, 'HH_Axon');
        end
    end
end