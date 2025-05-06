function drawContours(app,currentTimeStep)
colors{1} = [0,1,0];
colors{2} = [1,0,0];
colors{3} = [0,0,1];
xmean = 0; ymean = 0;
hold(app.ContourView, 'off');
imshow(app.SAXimg{currentTimeStep},[0 512],'Parent',app.ContourView, ...
    'Xdata',[1 size(app.SAXimg{currentTimeStep},2)*app.PixelSpacing(1)], ...
    'Ydata',[1 size(app.SAXimg{currentTimeStep},1)*app.PixelSpacing(2)]);
hold(app.ContourView, 'on');
% loop for contours
for i = 1 : size(app.CoordContours,2)
    tmp = squeeze(squeeze(app.CoordContours(currentTimeStep,i,:,:)));
    tmp(tmp==0) = [];
    tmp = reshape(tmp,[],2);
    plot(app.ContourView, tmp(:,1),tmp(:,2),'Color',colors{i});
    %                hold(app.ContourView, 'on');
    xmean = xmean + mean(tmp(:,1))/size(app.CoordContours,2);
    ymean = ymean + mean(tmp(:,2))/size(app.CoordContours,2);
end
% add reference points
plot(app.ContourView,app.RefPoints_midSepWall(currentTimeStep,1,1),app.RefPoints_midSepWall(currentTimeStep,1,2),'ko');
plot(app.ContourView,app.RefPoints_midSepWall(currentTimeStep,2,1),app.RefPoints_midSepWall(currentTimeStep,2,2),'ko');

if app.initialCall == 1
    xlim(app.ContourView, [xmean-75*app.PixelSize(1) xmean+75*app.PixelSize(1)]);
    ylim(app.ContourView, [ymean-75*app.PixelSize(2) ymean+75*app.PixelSize(2)]);
    app.initialCall = 0;
end

if ~isempty(app.ArchPoints)
    ang=0:0.01:2*pi;
    if ~isempty(app.ArchPoints{currentTimeStep,2}) % septal curvature
        plot(app.ContourView,app.ArchPoints{currentTimeStep,2}(:,1),app.ArchPoints{currentTimeStep,2}(:,2),'r-','LineWidth',2);
        xp=1/app.CurvatureSeptum(currentTimeStep,1)*cos(ang);
        yp=1/app.CurvatureSeptum(currentTimeStep,1)*sin(ang);
        plot(app.ContourView,app.ApproxCircleCenter(currentTimeStep,2,1)+xp,app.ApproxCircleCenter(currentTimeStep,2,2)+yp,'r--');
    end
    if ~isempty(app.ArchPoints{currentTimeStep,1}) % Free wall curvature
        plot(app.ContourView,app.ArchPoints{currentTimeStep,1}(:,1),app.ArchPoints{currentTimeStep,1}(:,2),'g-','LineWidth',2);
        xp=1/app.CurvatureFreeWall(currentTimeStep,1)*cos(ang);
        yp=1/app.CurvatureFreeWall(currentTimeStep,1)*sin(ang);
        plot(app.ContourView,app.ApproxCircleCenter(currentTimeStep,1,1)+xp,app.ApproxCircleCenter(currentTimeStep,1,2)+yp,'g--');
    end
end
hold(app.ContourView, 'off');
end