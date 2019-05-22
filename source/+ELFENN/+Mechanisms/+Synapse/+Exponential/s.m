function scaling = s(t, p)
    scaling = exp(-(t - p.t0)/p.tau) .* heaviside(t-p.t0);
    scaling = sum(scaling(isfinite(scaling))');
end
