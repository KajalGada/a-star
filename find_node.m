function node_num = find_node(x, y, node_lookup)
% display('I am here in find_node function.')
for find_node = 1:size(node_lookup,1)
    
    if node_lookup(find_node,1) == y
        
        if node_lookup(find_node,2) == x
            
            node_num = node_lookup(find_node, 3);
        
        end
    end
end
end