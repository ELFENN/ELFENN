function dY = ode(~, y, p)
    
    dY = zeros(size(y));
    Vm = y(1:1:end);
    
    membraneCurrent = -p.gL .* (Vm - p.EL);
    dY(1:1:end) = membraneCurrent / p.C;
end
