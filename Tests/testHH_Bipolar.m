classdef testHH_Bipolar < matlab.unittest.TestCase
    properties(TestParameter)
        filenames = {'slow bipolar axon', 'slow bipolar both', 'slow bipolar soma'};
    end
    methods(Test)
        function testHH_Bipolar_Neuron(testCase, filenames)
            NEURON_error(testCase, filenames, 'HH_Bipolar');
        end
        function testHH_Bipolar_LFP(testCase, filenames)
            if strcmp('slow bipolar both', filenames) % not implemented
                testCase.assumeTrue(true)
            else
                LFPy_error(testCase, filenames, 'HH_Bipolar');
            end
        end
    end
end