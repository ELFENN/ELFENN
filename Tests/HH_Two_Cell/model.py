import sys
from neuron import h, gui
import numpy as np

if __name__ == "__main__":
    args = sys.argv
    axon1 = h.Section(name='axon1')
    soma1 = h.Section(name='soma1')

    axon2 = h.Section(name='axon2')
    soma2 = h.Section(name='soma2')

    L_axon = float(args[1])
    L_soma = float(args[2])
    Ra = float(args[3])
    amp_axon = float(args[4])
    amp_soma = float(args[5])
    diam_axon = float(args[6])
    diam_soma = float(args[7])
    model_name = args[8]
    print('Running:\t' + model_name)

    nseg_axon = int(args[9])
    nseg_soma = int(args[10])
    sim_length = float(args[11])
    save_dir = args[-1]

    axon1.L = L_axon
    axon1.diam = diam_axon
    axon1.nseg = nseg_axon
    axon1.Ra = Ra
    axon1.insert('hh')

    soma1.L = L_soma
    soma1.diam = diam_soma
    soma1.nseg = nseg_soma
    soma1.Ra = Ra
    soma1.insert('hh')

    axon1.connect(soma1(1))

    axon2.L = L_axon
    axon2.diam = diam_axon
    axon2.nseg = nseg_axon
    axon2.Ra = Ra
    axon2.insert('hh')

    soma2.L = L_soma
    soma2.diam = diam_soma
    soma2.nseg = nseg_soma
    soma2.Ra = Ra
    soma2.insert('hh')

    axon2.connect(soma2(1))

    Iinjected1 = h.IClamp(soma1(0.5))  # middle of soma1 i.e. center of sphere
    Iinjected1.amp = amp_soma
    Iinjected1.delay = 0
    Iinjected1.dur = sim_length

    Iinjected2 = h.IClamp(axon2(0.5))  # middle of axon2 i.e. center of sphere
    Iinjected2.amp = amp_axon
    Iinjected2.delay = 0
    Iinjected2.dur = sim_length

    h.tstop = sim_length

    t_vec = h.Vector()  # Time stamp vector
    t_vec.record(h._ref_t)

    soma1_segments = list(soma1)
    v_vec = []
    for soma_segment in soma1_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(soma_segment._ref_v)

    soma2_segments = list(soma2)
    for soma_segment in soma2_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(soma_segment._ref_v)

    axon1_segments = list(axon1)
    for axon_segment in axon1_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(axon_segment._ref_v)

    axon2_segments = list(axon2)
    for axon_segment in axon2_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(axon_segment._ref_v)

    h.cvode_active(1)
    h.cvode.atol(1e-5)
    h.run()

    results = np.zeros((len(t_vec), len(soma1_segments) + len(axon1_segments) + len(soma2_segments) + len(axon2_segments) + 1))
    results[:, 0] = t_vec.as_numpy()
    for ix, v in enumerate(v_vec):
        results[:, ix + 1] = v_vec[ix]
        results[:, ix + 1] = v_vec[ix]

    np.savetxt(save_dir + "/modelResult/" + model_name + ".csv", results, delimiter=",")
