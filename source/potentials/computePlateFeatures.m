function [log_lookup_on_new_basis] = computePlateFeatures(network, recorders)
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
    platePlanes = network.platePlanes;
    platePoints = network.platePoints;
    plateSeparation = network.plateSeparation;
    
    log_lookup_on_new_basis = zeros(length(recorders), size(plateSeparation, 1));
    for ix = 1:size(plateSeparation, 1)
        point = platePoints(ix, :) * 1e-6;
        plane = platePlanes(ix, :);
        sep = plateSeparation(ix, :) * 1e-6;
        
        d = abs(sum((recorders * 1e-6 - point).*plane, 2)) / norm(plane);
        
        %     p = eCellPosition(ix, :)*1e-6; % scaling to SI unit
        %     d = sqrt(sum((recorders(:,:)*1e-6 - p).^2,2));
        log_lookup_on_new_basis(:, ix) = 1 - d / sep; %1./(4*pi*d);
    end
    
    %------------- END OF CODE --------------
end
