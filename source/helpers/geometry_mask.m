function [mask] = geometry_mask(network, x, y, offset)
    mask = zeros(size(x));
    for cell = network.cells
        for section = cell.sections
            p0 = section.startPoint;
            p1 = section.endPoint;
            r = section.radius;
            
            if ~section.isCylinder
                blank_ix = ((x - section.midpoint(1)).^2 + (y - section.midpoint(2)).^2 + (offset - section.midpoint(3)).^2) <= r.^2;
                mask(blank_ix) = 1;
            else
                
                if (p0(3) + r >= offset) && (p1(3) - r <= offset)
                    points = get_rectangle(p0, p1, r);
                    
                    inside = inpolygon(x(:), y(:), points(:, 1), points(:, 2));
                    mask(inside) = 1;
                    
                end
            end
        end
    end
    
    
end
