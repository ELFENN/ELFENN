function computeall(deleteTruth)
    testPath = 'Tests';
    d = dir(testPath);
    isub = [d(:).isdir];
    neuronModels = {d(isub).name}';
    neuronModels(ismember(neuronModels, {'.', '..'})) = [];
    
    for ix = 1:length(neuronModels)
        modelName = cell2mat(neuronModels(ix));
        modelPath = [testPath, '/', modelName];
        matlabPath = [modelPath, '/', 'MATLAB_Results'];
        neuronPath = [modelPath, '/', 'NEURON_Results'];
        
        disp(modelName);
        addpath(modelPath);
        if exist(matlabPath, 'dir')
            rmdir(matlabPath, 's');
        end
        
        mkdir(matlabPath);
        if deleteTruth
            if exist(neuronPath, 'dir')
                rmdir(neuronPath, 's');
            end
            mkdir(neuronPath);
        end
        
        configPath = [modelPath, '/model_configurations.json'];
        configFile = fileread(configPath);
        configFile = jsondecode(configFile);
        
        models = fieldnames(configFile);
        for model = 1:length(models)
            modelVersion = cell2mat(models(model));
            configuration = configFile.(modelVersion);
            configuration.save_name = [matlabPath, '/', configuration.name];
            disp(['  Running: ', configuration.name]);
            feval(['run', modelName], configuration);
            
            if deleteTruth
                py_model = [modelPath, '/model.py'];
                extension = '.csv';
                cmd = ['python -c "from ServerInterface import ServerInterface;', ...
                    'SI = ServerInterface();', ...
                    'SI.runmodel(', ...
                    '\"', py_model, '\",\"', modelName, '\",\"', configPath, '\",\"', ...
                    modelVersion, '\",\"', strrep(configuration.save_name, 'MATLAB', 'NEURON'), extension, '\")"'];
                
                
                
                disp(['  Running: ', configuration.name, ' NEURON']);
                system(cmd);
                
                if ix ~= 4 % There IS NO 2-cell LFP model
                    py_model = [modelPath, '/LFP_model.py'];
                    extension = '_LFP.mat';
                    cmd = ['python -c "from ServerInterface import ServerInterface;', ...
                        'SI = ServerInterface();', ...
                        'SI.runmodel(', ...
                        '\"', py_model, '\",\"', modelName, '\",\"', configPath, '\",\"', ...
                        modelVersion, '\",\"', strrep(configuration.save_name, 'MATLAB', 'NEURON'), extension, '\")"'];
                    
                    
                    
                    disp(['  Running: ', configuration.name, ' LFPy']);
                    system(cmd);
                end
            end
        end
        rmpath(modelPath);
    end
end