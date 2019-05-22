import sys
import LFPy
import numpy as np
from scipy.io import savemat

if __name__ == "__main__":
    args = sys.argv
    model_name = args[5]
    print('Running:\t' + model_name)

    L_axon = float(args[1])
    L_soma = float(args[2])
    Ra = float(args[3])
    amp = float(args[4])
    diam_axon = float(args[5])
    diam_soma = float(args[6])
    model_name = args[7]
    print('Running:\t' + model_name)

    nseg_axon = int(args[8])
    nseg_soma = int(args[9])
    sim_length = float(args[10])
    z_injected = args[11]
    save_dir = args[-1]

    model = 'model.hoc'
    hoc_string = "create soma\ncreate axon1\ncreate axon2 " \
                 "\nsoma{\n\tnseg = "+str(nseg_soma)+"\n\t" \
                 "pt3dadd("+str(-diam_soma/2)+",0,0,"+str(diam_soma)+")\n\t" \
                 "pt3dadd("+str(diam_soma/2)+",0,0,"+str(diam_soma)+")\n}" \
                 "\naxon1{\n\tnseg = "+str(nseg_axon)+"\n\t" \
                 "pt3dadd("+str(diam_soma/2)+",0,0,"+str(diam_axon)+")\n\t" \
                 "pt3dadd("+str(diam_soma/2 + L_axon)+",0,0,"+str(diam_axon)+")\n}" \
                 "\naxon2{\n\tnseg = "+str(nseg_axon)+"\n\t" \
                 "pt3dadd("+str(-diam_soma/2)+",0,0,"+str(diam_axon)+")\n\t" \
                 "pt3dadd("+str(-diam_soma/2 - L_axon)+",0,0,"+str(diam_axon)+")\n}" \
                 "\nconnect axon1(0), soma(1)\nconnect axon2(0), soma(0)"
    with open(save_dir + "/" + model, 'w') as file:
        file.write(hoc_string)

    cell_parameters = {
        'morphology': save_dir + '/' + model,
        'cm': 1.0,  # membrane capacitance
        'Ra': Ra,  # axial resistance (Ohm cm?)
        'v_init': -65.,  # initial crossmembrane potential (mV?)
        'passive': False,  # turn on NEURONs passive mechanism for all sections
        'nsegs_method': None,  # spatial discretization method
        'tstart': 0.,  # start time of simulation, recorders start at t=0
        'tstop': sim_length,  # stop simulation at 100 ms.
        'dt' : 0.1
    }

    cell = LFPy.Cell(**cell_parameters)
    cell.set_pos(0., 0, 0)

    for i, sec in enumerate(cell.allseclist):
        sec.Ra = Ra
        sec.insert('hh')

    pointprocess = {
        'record_current': True,
        'pptype': 'IClamp',
        'amp': amp,
        'dur': sim_length,
        'delay': 0
    }

    if z_injected == "soma":
        pointprocess['idx'] = cell.get_idx(section='soma')[0]
    elif z_injected == 'axon':
        pointprocess['idx'] = cell.get_idx(section='axon1')[10]
    else:
        print("Bipolar LFP not implemented")
        raise SystemExit(0)
    # Create synapse and set time of synaptic input
    stimulus = LFPy.StimIntElectrode(cell, **pointprocess)

    x = np.arange(L_soma, 1.2 * L_axon + 1, 1)
    y = np.array([1, 1.5, 2])
    X, Y = np.meshgrid(x, y)
    Z = np.zeros(X.shape)

    # Define electrode parameters
    grid_electrode_parameters = {
        'sigma': 0.05,  # extracellular conductivity (S/m?)
        'x': X.flatten(),  # electrode requires 1d vector of positions
        'y': Y.flatten(),  # electrode requires 1d vector of positions
        'z': Z.flatten(),
        'method': 'soma_as_point',  # treat soma segment as line source
    }

    print("running simulation...")
    cell.simulate(rec_imem=True, variable_dt=True, atol=1e-5)

    # Create electrode objects

    # Calculate LFPs
    electrode = LFPy.RecExtElectrode(cell, **grid_electrode_parameters)
    electrode.calc_lfp()
    LFP = electrode.LFP.reshape(X.shape[0], X.shape[1], electrode.LFP.shape[-1])
    t = np.arange(0, LFP.shape[-1]) * cell.dt

    save_object = {'LFP': LFP, 't': t, 'X': X, 'Y': Y}
    savemat(save_dir + "/modelResult/" + model_name + "_LFP.mat", mdict=save_object)
    #with open(save_dir + "/Neuron_Data/" + model_name + "_LFP.pickle", 'wb') as file:
    #    pickle.dump(save_object, file, protocol=pickle.HIGHEST_PROTOCOL)

