function [m,b] = linCoeff( x,y )
%linCoeff - Return linear y = m*x + b ftn handle given TWO data points

% coefficients
m = (y(2) - y(1))/(x(2) - x(1));
b = y(1) - m*x(1);

end

