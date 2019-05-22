function i_syn = recreate_synaptic_current(ts, synapse_params, f)
    
    i_syn = zeros(size(ts));
    ix = 1;
    for t = ts(:)'
        i_syn(ix) = synapse_params.gSyn * f(t, synapse_params);
        ix = ix + 1;
    end
end
