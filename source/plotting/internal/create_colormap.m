function color_handle = create_colormap(data, nLevels, map)
    %CREATE_COLORMAP Summary of this function goes here
    %   Detailed explanation goes here
    
    data = data(:);
    lower_bound = min(data);
    upper_bound = max(data);
    map = map(nLevels);
    m = (nLevels - 1) / (upper_bound - lower_bound);
    
    color_handle = @(d) map(round(m*d+(1 - m * lower_bound)), :);
end
