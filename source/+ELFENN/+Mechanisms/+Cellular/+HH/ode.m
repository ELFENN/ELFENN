function dY = ode(~, y, p)
    
    am = @(v) 0.1 * (v + 40) ./ (1 - exp(-0.1*(v + 40)));
    bm = @(v) 4 * exp(-0.0555556*(v + 65));
    
    ah = @(v) 0.07 * exp(-0.05*(v + 65));
    bh = @(v) 1 ./ (1 + exp(0.1*(-v - 35)));
    
    an = @(v) 0.01 * (v + 55) ./ (1 - exp(-0.1*(v + 55)));
    bn = @(v) 0.125 * exp(-0.0125*(v + 65));
    
    dY = zeros(size(y));
    Vm = y(1:4:end);
    m = y(2:4:end);
    h = y(3:4:end);
    n = y(4:4:end);
    
    membraneCurrent = (-m.^3 .* h .* p.gNa .* (Vm - p.ENa) - ...
        n.^4 .* p.gK .* (Vm - p.EK) - p.gL .* (Vm - p.EL));
    
    
    dY(1:4:end) = membraneCurrent / p.C;
    dY(2:4:end) = (am(Vm) .* (1 - m) - bm(Vm) .* m);
    dY(3:4:end) = (ah(Vm) .* (1 - h) - bh(Vm) .* h);
    dY(4:4:end) = (an(Vm) .* (1 - n) - bn(Vm) .* n);
end
