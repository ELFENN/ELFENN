function [log_lookup_on_new_basis] = computeLFPfeatures(network, positionToCalculate)
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
    [segmentRadius, segmentLength, segmentPosition, segmentVector, segmentStyle] = network.getlfpparameters();
    positionToCalculate = positionToCalculate * 1e-6;
    rotationMatrixArray = zeros(3, 3, size(segmentVector, 1));
    for ix = 1:size(segmentVector, 1)
        rotationMatrixArray(:, :, ix) = getrotationmatrixofvector(segmentVector(ix, :));
    end
    
    log_lookup_on_new_basis = zeros(size(positionToCalculate, 1), size(segmentVector, 1));
    for ix = 1:size(segmentVector, 1)
        if segmentStyle(ix)
            point_on_new_basis = ((positionToCalculate(:, :) - segmentPosition(ix, :)) * rotationMatrixArray(:, :, ix)) - [0, segmentLength(ix) / 2, 0];
            x = point_on_new_basis(:, 1);
            y = point_on_new_basis(:, 2);
            z = point_on_new_basis(:, 3);
            l = segmentLength(ix);
            d = sqrt(x.^2+y.^2+z.^2);
            r = segmentRadius(ix);
            log_lookup_on_new_basis(:, ix) = r * log(abs((d - y)./(sqrt((l + y).^2+(x.^2 + z.^2)) - (l + y))));
        else
            d = sqrt(sum((positionToCalculate(:, :) - segmentPosition(ix, :)).^2, 2));
            log_lookup_on_new_basis(:, ix) = segmentRadius(ix).^2 * 2 ./ d; % *2 so factor of 2 in other denominator cacles out also divided by r redundnatly for same reason
        end
    end
    
    %------------- END OF CODE --------------
end
