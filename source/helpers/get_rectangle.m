function [points] = get_rectangle(p0, p1, r)
    m = (p1(2) - p0(2)) ./ (p1(1) - p0(1));
    if m == 0        
        points = [p0 + [0, r, 0]; ...
            p0 - [0, r, 0]; ...
            p1 + [0, r, 0]; ...
            p1 - [0, r, 0]];
                        
        ch = convhull(points(:, 1), points(:, 2));
        points = points(ch, :);
        
    else
        m_perp = -1 / m;
                
        dx = sqrt(r^2/(1 + m_perp^2));
        dy = m_perp * dx;
                
        points = [p0 + [dx, dy, 0]; ...
            p0 - [dx, dy, 0]; ...
            p1 + [dx, dy, 0]; ...
            p1 - [dx, dy, 0]];                
        
        ch = convhull(points(:, 1), points(:, 2));
        points = points(ch, :);
    end
end