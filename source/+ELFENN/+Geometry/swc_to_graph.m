function [nodes, G] = swc_to_graph(filename)
    % ADAPTED FROM importSWC.m by ER Anderson
    delimiter = ' ';
    formatSpec = '%f%f%f%f%f%f%f%[^\n\r]';
    fileID = fopen(filename, 'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'ReturnOnError', false, 'CommentStyle', '#');
    fclose(fileID);
    id = dataArray{:, 1};
    section_class = dataArray{:, 2};
    start_x = dataArray{:, 3};
    start_y = dataArray{:, 4};
    start_z = dataArray{:, 5};
    radius = dataArray{:, 6};
    parent = dataArray{:, 7};
    clearvars filename delimiter formatSpec fileID dataArray ans;
    
    nodes.id = id;
    nodes.diameter = section_class;
    nodes.posX = start_x;
    nodes.posY = start_y;
    nodes.posZ = start_z;
    nodes.posR = radius;
    nodes.parent = parent;
    i = [];
    j = [];
    s = [];
    for ii = 2:length(nodes.id) %start at node 2 to avoid root node with -1 but keep its geometry!
        i = [i, nodes.id(ii)];
        j = [j, nodes.parent(ii)];
        s = [s, 1];
        i = [i, nodes.parent(ii)];
        j = [j, nodes.id(ii)];
        s = [s, 1]; %symmetric it
    end
    %
    for ii = 1:length(nodes.id)
        GEOM(ii, :) = [nodes.posX(ii), nodes.posY(ii), nodes.posZ(ii), nodes.posR(ii)]; %build geom array starting at parent
    end
    
    A = sparse(i, j, s);
    A = triu(A);
    G = digraph(A);
    
end
