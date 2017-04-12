function [ms] = mm2motorSteps(mm)
%mm2motorSteps Converts mili-meter to motor steps
%   Detailed explanation goes here
ms= (100 / (pi * 48)) * mm;


end

