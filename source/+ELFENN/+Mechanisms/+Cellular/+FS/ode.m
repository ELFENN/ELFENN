function [dY] = ode(~, y, p)
    
    am = @(v) 40 .* (v - 75.5) ./ (1 - exp(-(v - 75.5)/13.5));
    bm = @(v) 1.2262 ./ (exp(v/42.248));
    
    ah = @(v) 0.0035 ./ (exp(v/24.186));
    bh = @(v) 0.017 .* (v + 51.25) ./ (1 - exp(-(v + 51.25)/5.2));
    
    aq = @(v)(v - 95.) ./ (1 - exp(-(v - 95.)/11.8));
    bq = @(v)0.025 ./ (exp(v/22.222));
    
    an = @(v)0.014 * (v + 44.) ./ (1 - exp(-(v + 44.)/2.3));
    bn = @(v) 0.0043 ./ (exp((v + 44.)/34.));
    
    dY = zeros(size(y));
    Vm = y(1:5:end);
    m = y(2:5:end);
    h = y(3:5:end);
    n = y(4:5:end);
    q = y(5:5:end);
    
    membraneCurrent = ( ...
        -p.gNa .* m.^3 .* h .* (Vm - p.ENa) ...
        -p.gK_v3 .* q.^2 .* (Vm - p.EK) ...
        -p.gK_v1 .* n.^4 .* (Vm - p.EK) ...
        -p.gL .* (Vm - p.EL));
    
    
    dY(1:5:end) = membraneCurrent / p.C;
    dY(2:5:end) = (am(Vm) .* (1 - m) - bm(Vm) .* m);
    dY(3:5:end) = (ah(Vm) .* (1 - h) - bh(Vm) .* h);
    dY(4:5:end) = (an(Vm) .* (1 - n) - bn(Vm) .* n);
    dY(5:5:end) = (aq(Vm) .* (1 - q) - bq(Vm) .* q);
end