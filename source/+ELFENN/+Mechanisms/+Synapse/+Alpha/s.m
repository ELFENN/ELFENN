function scaling = s(t, p)
    scaling = exp(1) .* (t - p.t0) ./ p.tau .* exp(-(t - p.t0)/p.tau) .* heaviside(t-p.t0);
    scaling = sum(scaling(isfinite(scaling))');
end
