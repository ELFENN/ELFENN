import sys
from neuron import h, gui
import numpy as np

if __name__ == "__main__":
    args = sys.argv
    axon = h.Section(name='axon')
    model_name = args[5]
    print('Running:\t' + model_name)

    L = float(args[1])
    diam = float(args[4])
    nseg = int(args[6])
    Ra = float(args[2])
    amp = float(args[3])
    sim_length = float(args[7])
    save_dir = args[-1]

    axon.L = L
    axon.diam = diam
    axon.nseg = nseg
    axon.Ra = Ra
    axon.insert('hh')

    Iinjected = h.IClamp(axon(0))
    Iinjected.amp = amp
    Iinjected.delay = 0
    Iinjected.dur = sim_length

    h.tstop = sim_length

    t_vec = h.Vector()  # Time stamp vector
    t_vec.record(h._ref_t)

    axon_segments = list(axon)
    v_vec = []
    for axon_segment in axon_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(axon_segment._ref_v)

    h.cvode_active(1)
    h.cvode.atol(1e-5)
    h.run()

    results = np.zeros((len(t_vec), len(axon_segments) + 1))
    results[:, 0] = t_vec.as_numpy()
    for ix, v in enumerate(v_vec):
        results[:, ix + 1] = v_vec[ix]

np.savetxt(save_dir+"/modelResult/" + model_name + ".csv", results, delimiter=",")
