function [t_ix_matlab, t_ix_neuron] = interp_time_ix(matlab, neuron)
    
    interp_time = 0:0.5:36;
    t_ix_matlab = [];
    t_ix_neuron = [];
    for t = interp_time
        ds = abs(matlab.t-t);
        t_ix_matlab = [t_ix_matlab, find(ds == min(ds))];
        
        ds = abs(neuron.t-t);
        t_ix_neuron = [t_ix_neuron, find(ds == min(ds))];
        
    end
end
