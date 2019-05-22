function stimCurrent = sinusoidal_stimulus(t, ~, p)
    stimCurrent = p.amp * sin(2*pi*p.frequency*t+p.phi);
end