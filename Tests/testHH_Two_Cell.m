classdef testHH_Two_Cell < matlab.unittest.TestCase
    properties(TestParameter)
        filenames = {'short axon'};
    end
    methods(Test)
        function testHH_Two_Cell_NEURON(testCase, filenames)
            NEURON_error(testCase, filenames, 'HH_Two_Cell');
        end
    end
end