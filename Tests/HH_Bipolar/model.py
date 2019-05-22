import sys
from neuron import h, gui
import numpy as np

if __name__ == "__main__":
    args = sys.argv
    axon1 = h.Section(name='axon1')
    axon2 = h.Section(name='axon2')
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
    z_injected = args[11]

    save_dir = args[-1]

    axon1.L = axon2.L = L_axon
    axon1.diam = axon2.diam = diam_axon
    axon1.nseg = axon2.nseg = nseg_axon
    axon1.Ra = axon2.Ra = Ra
    axon1.insert('hh')
    axon2.insert('hh')

    soma.L = L_soma
    soma.diam = diam_soma
    soma.nseg = nseg_soma
    soma.Ra = Ra
    soma.insert('hh')

    axon1.connect(soma(1))
    axon2.connect(soma(0))

    if z_injected == 'axon':
        Iinjected = h.IClamp(0.5,sec=axon1)  # midway down axon

        Iinjected.amp = amp
        Iinjected.delay = 0
        Iinjected.dur = sim_length
    elif z_injected == 'soma':
        Iinjected = h.IClamp(0.5, sec=soma)  # middle of soma i.e. center of sphere

        Iinjected.amp = amp
        Iinjected.delay = 0
        Iinjected.dur = sim_length

    elif z_injected == 'both':
        Iinjected = h.IClamp(0.5, sec=axon1)  # midway down axon
        Iinjected2 = h.IClamp(0.5, sec=axon2)  # midway down axon

        Iinjected.amp = amp
        Iinjected.delay = 0
        Iinjected.dur = sim_length

        Iinjected2.amp = amp
        Iinjected2.delay = 0
        Iinjected2.dur = sim_length


    h.tstop = sim_length

    t_vec = h.Vector()  # Time stamp vector
    t_vec.record(h._ref_t)

    soma_segments = list(soma)
    v_vec = []
    for soma_segment in soma_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(soma_segment._ref_v)

    axon_segments = list(axon1)
    for axon_segment in axon_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(axon_segment._ref_v)

    axon_segments = list(axon2)
    for axon_segment in axon_segments:
        v_vec.append(h.Vector())
        v_vec[-1].record(axon_segment._ref_v)

    h.cvode_active(1)
    h.cvode.atol(1e-6)
    h.run()

    results = np.zeros((len(t_vec), len(soma_segments) + 2 * len(axon_segments) + 1))
    results[:, 0] = t_vec.as_numpy()
    for ix, v in enumerate(v_vec):
        results[:, ix + 1] = v_vec[ix]
        results[:, ix + 1] = v_vec[ix]

    np.savetxt(save_dir + "/modelResult/" + model_name + ".csv", results, delimiter=",")
