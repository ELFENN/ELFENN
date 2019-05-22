function [Vout] = calculatelfp_PH(network, Im, XX, YY, ZZ, sigma)
    %calculatelfp_PH - Calculate LFP for all time
    %This function only works for a plane of electodes if your plane is
    %parallel to one of the coordinate planes (XY, XZ, ...) then see
    %generate_electrode_grid
    %
    % Inputs:
    %    network - Solved network (ELFENN.Network)
    %    Im      - Membrane currents of all segments (double array)
    %    XX      - x-electrode locations(double array)
    %    YY      - y-electrode locations(double array)
    %    ZZ      - z-electrode locations(double array)
    %    sigma   - Conductivity of medium (double)
    %
    % Outputs:
    %    LFP - The measured LFP
    %
    % Example:
    %    Assumumig there is already a network called exampleNetwork, and a
    %    solved set of membrane currents called Im. If not please see
    %    ELFENN.Network, and ELFENN.Solver
    
    %    LFP is reshaped such that rows are time slices and columns are a
    %    linear array. to reshape a slice use reshape(LFP_slice, size(XX))
    %
    %    x = [-100, 100]; x_res = 1; %place electrodes between -100 and 100 microns spaced by 1 in x;
    %    y = [-30, 10]; x_res = 0.1;   %place electrodes between -30 and 10 microns spaced by 0.1 in y;
    %    z = [15, 15]; x_res = 1; %place electrodes at 15microns in z
    %
    %    [XX,YY,ZZ] = generate_electrode_grid(x, x_res, y, y_res, z, z_res);
    %    sigma = 0.05;
    %
    %    LFP = get_lfp_snapshot(network, Im, XX, YY, ZZ, sigma)
    %
    % see also generate_electrode_grid, ELFENN.Network, ELFENN.Sovler
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    x = XX(:);
    y = YY(:);
    z = ZZ(:);
    positionToCalculate = [x, y, z];
    [log_lookup_on_new_basis] = computeLFPfeatures(network, positionToCalculate);
    
    
    Vout = zeros(size(Im, 1), length(positionToCalculate));
    for ix = 1:size(Im, 1)
        V_contribution = repmat(Im(ix, :)/100, length(log_lookup_on_new_basis), 1) .* log_lookup_on_new_basis / (2 * sigma);
        Vout(ix, :) = 1e3 * sum(V_contribution, 2);
    end
    
    %------------- END OF CODE --------------
end