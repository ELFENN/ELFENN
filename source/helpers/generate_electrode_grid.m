function [XX, YY, ZZ] = generate_electrode_grid(x_bounds, x_res, y_bounds, y_res, z_bounds, z_res)
    %GENERATE_ELECTRODE_GRID - Create evenly spaced grid of electrodes
    %This function is intended for making a plane which alignes with one of the
    %coordinate planes (XY, XZ, ...). As such for easiest use one of the bounds
    %should be of the form [a1, a1] instead of [a1, a2].
    %
    % Inputs:
    %    x_bounds - [min_x, max_x] (double array)
    %    x_res - step between x (double)
    %    y_bounds - [min_y, max_y] (double array)
    %    y_res - step between y (double)
    %    z_bounds - [min_z, max_z] (double array)
    %    z_res - step between z (double)
    %
    % Outputs:
    %    XX - meshgrid of z
    %    YY - meshgrid of y
    %    ZZ - meshgrid of x
    %
    % Example:
    %    x = [-100, 100]; x_res = 1; %place electrodes between -100 and 100 microns spaced by 1 in x;
    %    y = [-30, 10]; x_res = 0.1;   %place electrodes between -30 and 10 microns spaced by 0.1 in y;
    %    z = [15, 15]; x_res = 1; %place electrodes at 15microns in z
    %
    %    [XX,YY,ZZ] = generate_electrode_grid(x, x_res, y, y_res, z, z_res);
    %
    % see also meshgrid
    
    % Author: Aaron R. Shifman, John E. Lewis
    % Center for Neural Dynamics, University of Ottawa, Canada
    % Department of Biology, University of Ottawa, Canada
    % Brain and Mind Research Institute, University of Ottawa, Canada
    % email address: ashifman@uottawa.ca
    
    %------------- BEGIN CODE --------------
    
    x = min(x_bounds):x_res:max(x_bounds);
    y = min(y_bounds):y_res:max(y_bounds);
    z = min(z_bounds):z_res:max(z_bounds);
    
    [XX, YY, ZZ] = meshgrid(x, y, z);
    
    %------------- END OF CODE --------------
end
