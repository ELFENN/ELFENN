function [log_lookup_on_new_basis] = computeElectrodeFeatures(network, recorders)
    %COMPUTELFPFEATURES - Precompute a scaling factor for each current.
    %Compute a feature that meaps each current source to a potential at each
    %recording.
    %
    % Inputs:
    %    network             - Solved network (ELFENN.Network)
    %    poisitonToCalculate - Measurement positions (double array)
    %
    % Outputs:
    %    log_lookup_on_new_basis - The scaling factor (double array)
    %
    % Example:
    %    Assumumig there is already a network called exampleNetwork, and a set
    %    of recording locations called r. If not please see ELFENN.Network.
    %
    %    log_lookup_on_new_basis = computeLFPfeatures(network, r);
    %
    % see also ELFENN.Network
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    import Algorythm.transforms.*
    eCellPosition = network.eCellPosition;
    log_lookup_on_new_basis = zeros(length(recorders), size(eCellPosition, 1));
    for ix = 1:size(eCellPosition, 1)
        p = eCellPosition(ix, :) * 1e-6; % scaling to SI unit
        d = sqrt(sum((recorders(:, :) * 1e-6 - p).^2, 2));
        log_lookup_on_new_basis(:, ix) = 1 ./ (4 * pi * d);
    end
    
    %------------- END OF CODE --------------
end
