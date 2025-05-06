function registration_points(app)
% registration
% looping
for t = 1 : app.TimeStepSpinner.Limits(2)-1
    img_to_register = app.SAXimg{1};
    img_ref         = app.SAXimg{t+1};
    % get the displacement matrix between t and t+1
    [D,~] = imregdemons(img_to_register,img_ref,[100,50,25],'AccumulatedFieldSmoothing',1.0,'DisplayWaitbar',false);
    % apply the displacement matrix to the points
    for ic = 1 : 2
        for ip = 1 : size(app.Points{ic,t},1)
            pixelx = app.Points{ic,1}(ip,1)/app.PixelSpacing(2);
            pixely = app.Points{ic,1}(ip,2)/app.PixelSpacing(1);
            dispx = D(floor(pixely):ceil(pixely),floor(pixelx):ceil(pixelx),1);
            dispy = D(floor(pixely):ceil(pixely),floor(pixelx):ceil(pixelx),2);
            pixelx_registered = pixelx - mean(dispx(:));
            pixely_registered = pixely - mean(dispy(:));
            app.Points{ic,t+1}(ip,1) = pixelx_registered*app.PixelSpacing(2);
            app.Points{ic,t+1}(ip,2) = pixely_registered*app.PixelSpacing(1);
        end
    end
    app.messagetxt.Value = ['Doing registration in phase (',num2str(t+1,'%0d'),'/',num2str(app.TimeStepSpinner.Limits(2),'%0d'),')...'];
    pause(0.01);
    % update contour view
    app.TimeStepSpinner.Value = t+1;
    currentTimeStep = t+1;
    drawManualCurves(app,currentTimeStep);
end
% compute curvatures and update plot (re-activate timeStepSpinner)
for t = 1 : app.TimeStepSpinner.Limits(2)
    [  ~,  ~, rinv ] = CircleFitting(app,app.Points{1,t}(:,1),app.Points{1,t}(:,2));
    app.CurvatureFreeWall(t,2) = rinv;
    [ cx, cy, rinv ] = CircleFitting(app,app.Points{2,t}(:,1),app.Points{2,t}(:,2));
    sept_to_freewall = mean(app.Points{1,t},1)-mean(app.Points{2,t},1);
    sept_to_center   = [cx cy] - mean(app.Points{2,t},1);
    if dot(sept_to_center,sept_to_freewall) > 0
        app.CurvatureSeptum(t,2)   = rinv;
    else
        app.CurvatureSeptum(t,2)   = -rinv;
    end
end
set(app.TimeStepSpinner,'Enable','on');
app.registrationDone = true;
drawManualCurves(app,currentTimeStep);
updateCurvaturePlot(app,app.CurvatureSeptum(:,2),app.CurvatureFreeWall(:,2));
end
