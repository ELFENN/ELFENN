import sys
import LFPy
import numpy as np
import pickle
from scipy.io import savemat

if __name__ == "__main__":
    args = sys.argv
    model_name = args[5]
    print('Running:\t' + model_name)

    L = float(args[1])
    diam = float(args[4])
    nseg = int(args[6])
    Ra = float(args[2])
    amp = float(args[3])
    sim_length = float(args[7])
    save_dir = args[-1]

    model = 'model.hoc'
    hoc_string = "create axon \naxon.nseg = " + str(nseg) + "\naxon.diam = " + str(diam) + "\naxon.L = " + str(L) + ""
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
    cell.set_rotation(x=np.pi / 2, y=0, z=0)
    cell.set_pos(L/(2*nseg), 0, 0)

    pointprocess = {
        'idx': 0,
        'record_current': True,
        'pptype': 'IClamp',
        'amp': amp,
        'dur': sim_length,
        'delay': 0
    }
    for i, sec in enumerate(cell.allseclist):
        sec.Ra = Ra
        sec.insert('hh')

    # Create synapse and set time of synaptic input
    stimulus = LFPy.StimIntElectrode(cell, **pointprocess)

    x = np.arange(0, 1.2 * L + 1, 1)
    y = np.array([1, 1.5, 2, 5, 10])
    X, Y = np.meshgrid(x, y)
    Z = np.zeros(X.shape)

    # Define electrode parameters
    grid_electrode_parameters = {
        'sigma': 0.05,  # extracellular conductivity (S/m?)
        'x': X.flatten(),  # electrode requires 1d vector of positions
        'y': Y.flatten(),  # electrode requires 1d vector of positions
        'z': Z.flatten()
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
