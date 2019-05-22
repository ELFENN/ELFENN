function plotLFP(network, LFP, E1, E2, offset, should_mask)
    %PLOTLFP - pcolor wrapper for LFP
    %
    % Inputs:
    %    LFP - LFP (double array)
    %    E1  - values for axis 1
    %    E2  - values for axis 2
    %
    % Outputs:
    %    None
    %
    % Example (default plot):
    %    Assuming LFP processing has already been done. If not see
    %    get_lfp_snapshot.
    %
    %    plotLFP(LFP, XX, YY);
    %
    % see also generate_electrode_grid, get_lfp_snapshot
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    
    LFP_mod = LFP;
    LFP_mod(isinf(LFP_mod)) = NaN;
    LFP_filled = fillmissing(LFP_mod, 'spline');
    
    if should_mask
        mask = geometry_mask(network, E1, E2, offset);
        LFP_filled(mask == 1) = NaN;
    end
    
    p = pcolor(E1, E2, LFP_filled);
    set(p, 'EdgeColor', 'none');
    set(gca, 'YDir', 'normal');
    set(p, 'ZData', p.ZData+offset);
    
    %------------- END OF CODE --------------
end
