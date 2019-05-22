function [tf] = isfirstorderpath(G, n1, n2)
    if isinf(distances(G, n1, n2))
        tf = 0;
    else
        nstar = n1;
        c = successors(G, nstar);
        d = distances(G, c, n2);
        [~, mix] = min(d);
        nstar = c(mix);
        while 1
            if nstar == n2
                tf = 1;
                break
            end
            c = successors(G, nstar);
            if length(c) > 1
                tf = 0;
                break
            end
            nstar = c(1);
        end
    end
end