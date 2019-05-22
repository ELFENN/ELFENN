function [cell] = load_swc(filename, varargin)
    p = inputParser();
    p.addRequired('filename', @(x) 1);
    p.addOptional('resolution', -1, @(x) 1);
    p.parse(filename, varargin{:});
    resolution = p.Results.resolution;
    [nodes, G] = ELFENN.Geometry.swc_to_graph(filename);
    if resolution ~= -1
        [nodes, G] = ELFENN.Geometry.decimate(nodes, G, resolution);
    end
    
    root_node = nodes.id(nodes.parent == -1);
    root_branches = nodes.id(nodes.parent == root_node);
    
    if length(root_branches) > 1
        needs_soma = 1;
    else
        needs_soma = 0;
    end    
    
    section_array = struct();
    cell = ELFENN.Cell('cell');
    if needs_soma
        r = 2; % If no true root node specified make a small 2um soma
        soma = ELFENN.Section('soma', 'SectionGeometry', 'S', 'radius', r, 'sectionLength', 2*r, 'nseg', 1, 'Ra', 100);
        for ix = 1:length(root_branches)
            %         if (nodes.diameter(root_branches(ix)) == 1) && (nodes.parent(root_branches(ix)) ~= -1)
            %             continue
            %         end % TODO:THIS!
            sectionName = "Section-" +num2str(root_node) + "-" +num2str(root_branches(ix));
            r = nodes.posR(root_branches(ix));
            end_point = [nodes.posX(root_branches(ix)), nodes.posY(root_branches(ix)), nodes.posZ(root_branches(ix))];
            l_eff = sqrt(sum(end_point.^2));
            start_point = soma.radius * end_point / l_eff;
            
            soma_branch = ELFENN.Section(sectionName, 'radius', r, 'sectionLength', -1, 'starting', start_point, 'ending', end_point, 'nseg', 1);
            cell.connectsection(soma, soma_branch, 'forced', 1);
            
            section_array.("s_" +num2str(root_node) + "_" +num2str(root_branches(ix))) = soma_branch;
        end
    end
    
    for ix = 1:size(G.Edges, 1)
        %disp(ix);
        start_entry = G.Edges.EndNodes(ix, 1);
        if (start_entry == root_node) && needs_soma
            continue
        end
        end_entry = G.Edges.EndNodes(ix, 2);
        
        r = mean(nodes.posR([start_entry, end_entry]));
        start_point = [nodes.posX(start_entry), nodes.posY(start_entry), nodes.posZ(start_entry)];
        end_point = [nodes.posX(end_entry), nodes.posY(end_entry), nodes.posZ(end_entry)];
        
        sectionName = "Section-" +num2str(start_entry) + "-" +num2str(end_entry);
        end_point = end_point - start_point;
        start_point = start_point - start_point;
        section = ELFENN.Section(sectionName, 'sectionLength', -1, 'radius', r, 'starting', start_point, 'ending', end_point, 'nseg', 1, 'Ra', 100); % HACK!
        section_array.("s_" +num2str(start_entry) + "_" +num2str(end_entry)) = section;
    end
    
    sorted = toposort(G);
    if ~needs_soma
        edge_1 = section_array.("s_" +num2str(sorted(1)) + "_" +num2str(sorted(2)));
        edge_2 = section_array.("s_" +num2str(sorted(2)) + "_" +num2str(sorted(3)));
        cell.connectsection(edge_1, edge_2);
        offset = 4;
    else
        offset = 1;
    end
    
    for ix = offset:length(sorted)
        if ~ismember(sorted(ix), root_branches) && (sorted(ix) ~= root_node)
            parent = predecessors(G, sorted(ix));
            grand_parent = predecessors(G, parent);
            parent_branch = section_array.("s_" +num2str(grand_parent) + "_" +num2str(parent));
            
            branch = section_array.("s_" +num2str(parent) + "_" +num2str(sorted(ix)));
            
            cell.connectsection(parent_branch, branch);
        else
            
        end
        
    end
end
