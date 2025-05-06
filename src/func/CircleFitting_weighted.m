function [cx,cy,rinv] = CircleFitting_weighted(app,x0,y0,weight)
% create matrices
v = x0.^2 + y0.^2;
A = [x0  y0  ones(size(x0))];
% weight (diagonal)
W = diag(weight);
x = (transpose(A)*W*A)\transpose(A)*W*v;
cx = x(1)/2;
cy = x(2)/2;
r = sqrt(x(3)+cx^2+cy^2);
rinv = 1/r;
end
