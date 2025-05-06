function drawSpline_tx_ty(app, x, y, nsplit,colorchar)
% draw spline curves on the contour view using a parameter t
t = 0:1/(length(x)-1):1;
ts = 0:1/(nsplit-1):1;
xs = spline(t,x,ts);
ys = spline(t,y,ts);
pl = plot(app.ContourView,xs,ys,[colorchar,'-'],'LineWidth',1.5);
set(pl,'HitTest','off');
end
