function scaling = s(t, p)
    scaling = (exp(-(t - p.t0)/p.decay) - exp(-(t - p.t0)/p.rise)) .* heaviside(t-p.t0);
    
    a = p.rise;
    b = p.decay;
    
    t_max = (a * b * log(a/b) + p.t0 * (a - b)) / (a - b);
    max_val = (exp(-(t_max - p.t0)/p.decay) - exp(-(t_max - p.t0)/p.rise)) .* heaviside(t_max-p.t0);
    scaling = scaling ./ max_val;
    
    scaling = sum(scaling(isfinite(scaling))');
end
