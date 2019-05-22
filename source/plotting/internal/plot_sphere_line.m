function [px, py, pz] = plot_sphere_line(center, r)
    %PLOT_SPHERE_LINE Summary of this function goes here
    %   Detailed explanation goes here
    
    resolution = 50;
    
    p = zeros(2*resolution, 3);
    
    theta = linspace(0, 2*pi, resolution)';
    p(1:resolution, 1:2) = [cos(theta), sin(theta)];
    
    p(resolution+1:end, 1) = cos(theta);
    p(resolution+1:end, 3) = sin(theta);
    
    p = p * r;
    p = p + center;
    
    px = p(:, 1);
    py = p(:, 2);
    pz = p(:, 3);
end
