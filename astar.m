clc;
close all; clear all;

%Start Point, Goal Point, Obstacle Points
start_x = 2;
start_y = 2;
goal_x = 6;
goal_y = 5;
obstacle = [4 3; 2 5; 2 7; 6 8; 9 4];

% Plot map

[X, Y] = meshgrid(1:11);
figure; hold on;
% set(axes, 'Ydir','reverse')
plot(X,Y,'k')
plot(Y,X,'k')
% axis off

node_lookup = [];

for r = 1:1:10
    for c = 1:1:10
        print_text = (c-1)*10 + r;
        text(r+0.8,c+0.8,num2str(print_text));
        node_lookup = [node_lookup; c r print_text];
    end
end

rectangle('Position',[start_x+0.25 start_y+0.25 0.5 0.5], 'Curvature', [1 1], ...
    'FaceColor', 'y')
text(start_x + 0.4, start_y + 0.5,'Start')

rectangle('Position',[goal_x+0.25 goal_y+0.25 0.5 0.5], 'Curvature', [1 1], ... 
    'FaceColor', 'r')
text(goal_x + 0.4, goal_y + 0.5,'Goal')

rectangle('Position',[4 3 1 1], 'FaceColor', 'k')
rectangle('Position',[2 5 1 1], 'FaceColor', 'k')
rectangle('Position',[2 7 1 1], 'FaceColor', 'k')
rectangle('Position',[6 8 1 1], 'FaceColor', 'k')
rectangle('Position',[9 4 1 1], 'FaceColor', 'k')

% Calculating the heuristic matrix
% Euclidean distance from goal

heuristic_matrix = [ones(10,10)];
heuristic_matrix_new = [];

for r = 1:10
    for c = 1:10
        heuristic_value = ( X(r,c) - goal_x )^2 + ( Y(r,c) - goal_y )^2;
        heuristic_value = heuristic_value^(1/2);
        heuristic_matrix(r,c) = heuristic_value;
        text(c+0.1,r+0.8,num2str(heuristic_value),'Color','blue');
        node_num = (r-1)*10 + c;
        heuristic_matrix_new = [heuristic_matrix_new; ...
            node_num heuristic_value];
    end
end

queue_open = [];
queue_close = [];

node_value_start = find_node(start_x,start_y,node_lookup)
node_value_goal = find_node(goal_x,goal_y,node_lookup)

queue_open = [queue_open node_value_start];

test_break = 0;
goal_reached = 0;

obstacle_node_list = [];

for obstacle_id = 1:size(obstacle,1)
    obstacle_node_value = find_node(obstacle(obstacle_id,1), ...
        obstacle(obstacle_id,2), node_lookup);
    obstacle_node_list = [obstacle_node_list; obstacle_node_value];
end

total_cost_matrix = [node_value_start node_value_start 0];
% [node parent_node cost]

while isempty(queue_open) == 0
    
    %display('Queue not empty')
    %display(queue_open);
    
    if size(queue_open) == 1
        node_evaluate = queue_open(1);
    else
        
        %display('Need a method to evaluate.');
        low_value = 100000000;
        
        for next_node_evaluate_id = 1:size(queue_open,2)
            
            queue_open(next_node_evaluate_id);
            
            total_cost_node_index = find(total_cost_matrix(:,1)...
                ==queue_open(next_node_evaluate_id));
            next_node_evaluate_cost = total_cost_matrix(...
                total_cost_node_index,3);
            
            if next_node_evaluate_cost < low_value
                
                low_value = next_node_evaluate_cost;
                node_evaluate = queue_open(next_node_evaluate_id);
                
            end
        end
    end
    
    %node_evaluate
    
    neighbours = find_neighbours(node_evaluate,obstacle_node_list);
    
    for neighbours_id = 1:size(neighbours,2)
        neighbours(neighbours_id);
        heuristic_cost_index = find(heuristic_matrix_new(:,1)...
            ==neighbours(neighbours_id));
        heuristic_cost = heuristic_matrix_new(heuristic_cost_index,2);
        parent_cost_index = find(total_cost_matrix(:,1)...
            ==node_evaluate);
        parent_cost = total_cost_matrix(parent_cost_index,3);
        movement_cost = parent_cost + 1;
        total_cost = heuristic_cost + movement_cost;
        
        if find(total_cost_matrix(:,1) == neighbours(neighbours_id))
            node_current_cost_value_index = ...
                find(total_cost_matrix(:,1) == neighbours(neighbours_id));
            node_current_cost_value = total_cost_matrix(...
                node_current_cost_value_index,3);
            total_cost;
            
            if total_cost < node_current_cost_value
                total_cost_matrix(node_current_cost_value_index,2) =...
                    node_evaluate;
                total_cost_matrix(node_current_cost_value_index,3) =...
                    total_cost;
            end
        else
            total_cost_matrix = [total_cost_matrix;...
                neighbours(neighbours_id) node_evaluate total_cost];
        end
    end
    
    %queue_open = [queue_open neighbours]
    neighbours_add = neighbours;
    for queue_open_check_id = 1:size(queue_open,2)
        neighbours_add = neighbours_add(neighbours_add ~= ...
            queue_open(queue_open_check_id));
    end
    
    queue_open = [queue_open neighbours_add];
    %queue_open = queue_open(queue_open~=node_evaluate)
    
    queue_close = [queue_close node_evaluate];
    
    for queue_close_check_id = 1:size(queue_close,2)
        queue_open = queue_open(...
            queue_open~=queue_close(queue_close_check_id));
    end
    
    if test_break == 50
        display('50 iterations over, thus stop.')
        break
    else
        test_break = test_break + 1;
    end
    
    if find(neighbours == node_value_goal) %goal_reached == 1
        display('Goal reached.')
        goal_reached = 1;
        break
    end
    
end

path = [];
%cost_path = 0;
if goal_reached == 1
    path = [path node_value_goal];
    node_next_path = node_value_goal;
    while node_next_path ~= node_value_start
        node_next_path_index = find(total_cost_matrix(:,1)...
            == node_next_path);
        node_next_path = total_cost_matrix(node_next_path_index,2);
        path = [path node_next_path];
    end
end

path




