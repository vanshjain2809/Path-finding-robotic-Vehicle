function [ x_cord, y_cord ] = interpolateLine( no_of_steps, px, py )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


fprintf(1,'\n function: interpolateLine: no_of_steps= %d', no_of_steps);
fprintf(1,'\n px(1) = %f    px(2) = %f', px(1), px(2));
fprintf(1,'\n py(1) = %f    py(2) = %f', py(1), py(2));

x_modifier = abs(px(2)  - px(1)) / no_of_steps;
y_modifier = abs(py(2)  - py(1)) / no_of_steps;

if px(1) > px(2)
    x_modifier = x_modifier * (-1);
end


if py(1) > py(2)
    y_modifier = y_modifier * (-1);
end


fprintf(1,'\n x_modifier = %f    y_modifier = %f', x_modifier, y_modifier);


x_cord = ones(1, no_of_steps + 1);
y_cord = ones(1, no_of_steps + 1);

x_cord(1) = px(1);
y_cord(1) = py(1);

for i = 1:no_of_steps
    x_cord(1+i) = x_cord(i) + x_modifier;
    y_cord(1+i) = y_cord(i) + y_modifier;
end


%fprintf(1,'\n');


end

