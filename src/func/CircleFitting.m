function [ cx, cy, rinv ] = CircleFitting(app,x,y)
x_sum   = sum(x);
y_sum   = sum(y);
xsq_sum = sum(x.^2);
ysq_sum = sum(y.^2);
xy_sum  = sum(x.*y);
c       = length(x);

LHS = [xsq_sum  xy_sum   x_sum;
    xy_sum   ysq_sum  y_sum;
    x_sum    y_sum    c     ];

RHS = [-sum(x.^3    +  x.*y.^2);
    -sum(x.^2.*y +  y.^3   );
    -sum(x.^2    +  y.^2   )];

X = LHS\RHS;

cx   = -X(1)/2;
cy   = -X(2)/2;
r    = sqrt(cx^2+cy^2-X(3));
rinv = 1/r;

end
