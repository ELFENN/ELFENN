classdef testHH_Soma_Axon < matlab.unittest.TestCase
    properties(TestParameter)
        filenames = {'short axon', 'slow axon'};
    end
    methods(Test)
        function testHH_Soma_Axon_NEURON(testCase, filenames)
            NEURON_error(testCase, filenames, 'HH_Soma_Axon');
        end
        function testHH_Soma_Axon_LFP(testCase, filenames)
            LFPy_error(testCase, filenames, 'HH_Soma_Axon');
        end
    end
end