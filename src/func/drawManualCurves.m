function drawManualCurves(app,currentTimeStep)
hold(app.ContourView, 'off');
hdl = imshow(app.SAXimg{currentTimeStep},[0 512],'Parent',app.ContourView, ...
    'Xdata',[1 size(app.SAXimg{currentTimeStep},2)*app.PixelSpacing(1)], ...
    'Ydata',[1 size(app.SAXimg{currentTimeStep},1)*app.PixelSpacing(2)]);
set(hdl,'HitTest','off');
hold(app.ContourView, 'on');
pl1 = plot(app.ContourView,app.Points{1,currentTimeStep}(:,1),app.Points{1,currentTimeStep}(:,2),'go');
pl2 = plot(app.ContourView,app.Points{2,currentTimeStep}(:,1),app.Points{2,currentTimeStep}(:,2),'ro');
set(pl1,'HitTest','off');
set(pl2,'HitTest','off');
drawSpline_tx_ty(app, app.Points{1,currentTimeStep}(:,1), app.Points{1,currentTimeStep}(:,2), 100,'g');
drawSpline_tx_ty(app, app.Points{2,currentTimeStep}(:,1), app.Points{2,currentTimeStep}(:,2), 100,'r');
end
