function testELFENN()
%TESTELFENN - Auto run models and tests
%
% Inputs:
%    None
%
% Outputs:
%    None
%
% Example:
%    runalltests;

% Author: Aaron R. Shifman, John E. Lewis
% Center for Neural Dynamics, University of Ottawa, Canada
% Department of Biology, University of Ottawa, Canada
% Brain and Mind Research Institute, University of Ottawa, Canada
% email address: ashifman@uottawa.ca

%------------- BEGIN CODE --------------

disp('Welcome to the ELFENN Unit Test Suite')
disp('These tests will run a set of models in ELFENN and compare the results to NEURON and LFPy')
disp('Would you Like to recompute existing NEURON/LFPy simulations?')
disp('Recomputing existing results requires remote configuration and is not recommended for basic installs')
deleteTruth = input('Recompute? (y|n)', 's');
deleteTruth = strcmp(deleteTruth, 'y');

if deleteTruth
    disp('NEURON and LFPy tests are configured to run on a remote server')
    disp('If you have not already done so:')
    fprintf('\t please configure the server connections in Tests/config.example.json\n')
    fprintf('\t please rename Tests/config.example.json -> Tests/config.json\n')
    disp('Please also be aware of the following')
    disp('Due to server configuration issues, the Python binary and the NEURON library have been hard-coded')
    fprintf('\t Python: ServerInterface.Py\n')
    fprintf('\t NEURON: Tests/Test_dir/model.py\n')
    fprintf('\t LFPy: Tests/Test_dir/LFP_model\n')
    disp('For any questions please contact Aaron Shifman at')
    fprintf('\t ashifman@uottawa.ca\n')
    
    input('Press Enter When Ready');
end

curr_dir = pwd();
cd(fileparts(which(mfilename)));

mfilepath=fileparts(which(mfilename));
addpath(fullfile(mfilepath,'/Tests'));
computeall(deleteTruth);
runtests(fullfile(mfilepath,'/Tests'))
rmpath(fullfile(mfilepath,'/Tests'));

% clean up matlab tests
d = dir('Tests/');
isub = [d(:).isdir];
neuronModels = {d(isub).name}';
neuronModels(ismember(neuronModels,{'.','..'})) = [];

for ix = 1:length(neuronModels)
    modelName = cell2mat(neuronModels(ix));
    modelPath = ['Tests/' modelName];
    matlabPath = [modelPath '/' 'MATLAB_Results'];
    
    rmdir(matlabPath, 's');
end

cd(curr_dir);

%------------- END OF CODE --------------
end