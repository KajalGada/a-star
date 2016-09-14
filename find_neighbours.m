function neighbours = find_neighbours(node_center, obstacle_node_list)
if mod(node_center,10) == 1
    if node_center == 1
        neighbours = [node_center+1 node_center+10 node_center+11];
    else
        if node_center == 91
            neighbours = [node_center+1 node_center-10 node_center-9];
        else
            neighbours = [node_center+1 ...
                node_center+10 node_center-10 ...
                node_center+11 node_center-9];
        end
    end
    
else
    if mod(node_center,10) == 0
        if node_center == 10
            neighbours = [node_center-1 node_center+10 node_center+9];
        else
            if node_center == 100
                neighbours = [node_center-1 node_center-10 node_center-11];
            else
                neighbours = [node_center-1 ...
                    node_center+10 node_center-10 ...
                    node_center+9 node_center-11];
            end
        end
    else
        if node_center < 10
            neighbours = [node_center+1 node_center-1 ...
                node_center+10 node_center+11 node_center+9];
        else
            if node_center > 90
                neighbours = [node_center+1 node_center-1 ...
                    node_center-10 node_center-11 node_center-9];
            else
                neighbours = [node_center+1 node_center-1 ...
                    node_center+10 node_center-10 ...
                    node_center+11 node_center-11 ...
                    node_center+9 node_center-9];
            end
        end
    end
end

for ob_check_id = 1:size(obstacle_node_list,1)
    neighbours = neighbours(neighbours~=obstacle_node_list(ob_check_id));
end

end