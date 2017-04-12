function [mm] = pixel2mm(x_cordinates,y_cordinates)
%pixel2mm This function converts number of pixels to mili-meter
%   Detailed explanation goes here

mm = sqrt(abs(x_cordinates(2)-x_cordinates(1))*abs(x_cordinates(2)-x_cordinates(1))+abs(y_cordinates(2)-y_cordinates(1))*abs(y_cordinates(2)-y_cordinates(1)))*2.7833;

end

