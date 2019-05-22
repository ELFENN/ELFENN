import sys
from neuron import h, gui
import numpy as np

if __name__ == "__main__":
    args = sys.argv
    axon = h.Section(name='axon')
    soma = h.Section(name='soma')

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
    save_dir = args[-1]

    axon.L = L_axon
    axon.diam = diam_axon
    axon.nseg = nseg_axon
    axon.Ra = Ra
    axon.insert('hh')

    soma.L = L_soma
    soma.diam = diam_soma
    soma.nseg = nseg_soma
    soma.Ra = Ra
    soma.insert('hh')

    axon.connect(soma(1))

    Iinjected = h.IClamp(soma(0.5))  # middle of soma i.e. center of sphere
    Iinjected.amp = amp
    Iinjected.delay = 0
    Iinjected.dur = sim_length

    h.tstop = sim_length

    t_vec = h.Vector()  # Time stamp vector
    t_vec.record(h._ref_t)

    soma_segments = list(soma)
    v_vec = []
    for soma_segment in soma_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(soma_segment._ref_v)


    axon_segments = list(axon)
    for axon_segment in axon_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(axon_segment._ref_v)

    h.cvode_active(1)
    h.cvode.atol(1e-5)
    h.run()

    results = np.zeros((len(t_vec), len(soma_segments) + len(axon_segments) + 1))
    results[:, 0] = t_vec.as_numpy()
    for ix, v in enumerate(v_vec):
        results[:, ix + 1] = v_vec[ix]
        results[:, ix + 1] = v_vec[ix]

    np.savetxt(save_dir + "/modelResult/" + model_name + ".csv", results, delimiter=",")
