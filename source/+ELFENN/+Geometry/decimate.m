function [new_nodes, decimated] = decimate(Nodes, G, resolution)
    G.Nodes.id = Nodes.id;
    G.Nodes.diameter = Nodes.diameter;
    G.Nodes.posX = Nodes.posX;
    G.Nodes.posY = Nodes.posY;
    G.Nodes.posZ = Nodes.posZ;
    G.Nodes.posR = Nodes.posR;
    
    branch_nodes = find(outdegree(G) > 1);
    end_nodes = find(outdegree(G) == 0);
    
    branch_ranges = [];
    for b1 = branch_nodes'
        for b2 = [branch_nodes; end_nodes]'
            if b1 == b2
                continue
            end
            tf = ELFENN.Geometry.isfirstorderpath(G, b1, b2);
            if tf
                branch_ranges = [branch_ranges; [b1, b2]];
            end
        end
    end
    
    % for b1 = branch_nodes'
    %     for b2 = end_nodes'
    %         if b1 == b2
    %             continue
    %         end
    %         tf = isfirstorderpath(G, b1, b2);
    %         if tf
    %             branch_ranges = [branch_ranges; [b1, b2]];
    %         end
    %     end
    % end
    keepers = [];
    for pair = branch_ranges'
        row = find(G.Nodes.id == pair(1));
        id = G.Nodes.id(row);
        x = G.Nodes.posX(row);
        y = G.Nodes.posY(row);
        z = G.Nodes.posZ(row);
        state = [pair(1), x, y, z];
        
        c = pair(1);
        while 1
            c = successors(G, c);
            d = distances(G, c, pair(2));
            [~, mix] = min(d);
            c = c(mix);
            
            row = find(G.Nodes.id == c);
            id = G.Nodes.id(row);
            x = G.Nodes.posX(row);
            y = G.Nodes.posY(row);
            z = G.Nodes.posZ(row);
            state = [state; id, x, y, z];
            
            if c == pair(2)
                break
            end
            
        end
        kept0 = state(1, 1);
        
        cum_dist = cumsum(sqrt(sum((state(2:end, [2, 3, 4]) - state(1:end-1, [2, 3, 4])).^2, 2)));
        delta = floor(cum_dist(end)/resolution);
        
        if delta == 0
            %for ix = 2:(size(state,1));
            n = [kept0, state(end, 1)];
            if n(1) ~= n(2)
                keepers = [keepers; n];
            end
            kept0 = state(end, 1);
            %end
        else
            for ix = 1:delta
                f = find(cum_dist >= resolution*ix);
                n = [kept0, state(f(1)+1, 1)];
                if n(1) ~= n(2)
                    keepers = [keepers; n];
                end
                kept0 = state(f(1)+1, 1);
            end
            
            if keepers(end, 2) ~= pair(2)
                keepers = [keepers; kept0, pair(2)];
            end
        end
    end
    
    decimated = digraph();
    decimated = addnode(decimated, G.Nodes);
    for e = keepers'
        decimated = addedge(decimated, e(1), e(2));
    end
    
    disconnected = find((indegree(decimated) == 0).*(outdegree(decimated) == 0));
    decimated = rmnode(decimated, disconnected);
    
    %    h = plot(G, 'layout', 'force');
    %highlight(h, decimated.Nodes.id, 'nodecolor', 'r');
    %     figure;
    %     plot(G, 'XData', G.Nodes.posX,...
    %         'YData', G.Nodes.posY,...
    %         'ZData', G.Nodes.posZ)
    %
    %     figure;
    %     plot(decimated, 'XData', decimated.Nodes.posX,...
    %     'YData', decimated.Nodes.posY,...
    %     'ZData', decimated.Nodes.posZ)
    
    decimated.Nodes.id = (1:length(decimated.Nodes.id))';
    
    new_nodes.id = decimated.Nodes.id;
    new_nodes.diameter = decimated.Nodes.diameter;
    new_nodes.posX = decimated.Nodes.posX;
    new_nodes.posY = decimated.Nodes.posY;
    new_nodes.posZ = decimated.Nodes.posZ;
    new_nodes.posR = decimated.Nodes.posR;
    
    parents = [];
    for id = new_nodes.id'
        parent = predecessors(decimated, id);
        if isempty(parent)
            parents = [parents; -1];
        else
            parents = [parents; parent];
        end
    end
    new_nodes.parent = parents;
    
    %decimated.Nodes = decimated.Nodes.id;
end