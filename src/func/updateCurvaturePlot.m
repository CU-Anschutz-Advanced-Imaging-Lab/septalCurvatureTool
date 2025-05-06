function updateCurvaturePlot(app,SeptalCurvature,FreewallCurvature)
% obtain class variables
ntemp        = app.TimeStepSpinner.Limits;
if strcmp(app.CurvatureareaDropDown.Value,'Line-based')
    areaApproach = 1;
else
    areaApproach = 2;
end
% curvatures
% plot
plot(app.CurvatureView,ntemp(1):1:ntemp(2),SeptalCurvature,'ro');
hold(app.CurvatureView,'on');
y = spline(ntemp(1):1:ntemp(2),SeptalCurvature,ntemp(1):0.1:ntemp(2));
pl_sc = plot(app.CurvatureView,ntemp(1):0.1:ntemp(2),y,'r-');

plot(app.CurvatureView,ntemp(1):1:ntemp(2),FreewallCurvature,'go');
y = spline(ntemp(1):1:ntemp(2),FreewallCurvature,ntemp(1):0.1:ntemp(2));
pl_fwc = plot(app.CurvatureView,ntemp(1):0.1:ntemp(2),y,'g-');

app.CurvatureRatio = SeptalCurvature./FreewallCurvature;
app.CurvatureRatio(isnan(app.CurvatureRatio)) = 0;

plot(app.CurvatureRatioView,ntemp(1):1:ntemp(2),app.CurvatureRatio,'ko');
hold(app.CurvatureRatioView,'on');
y = spline(ntemp(1):1:ntemp(2),app.CurvatureRatio,ntemp(1):0.1:ntemp(2));
plot(app.CurvatureRatioView,ntemp(1):0.1:ntemp(2),y,'k-');

% current time
xline(app.CurvatureView,app.TimeStepSpinner.Value);
yline(app.CurvatureView,0);
xline(app.CurvatureRatioView,app.TimeStepSpinner.Value);
yline(app.CurvatureRatioView,0);

% figure legends
legend(app.CurvatureView,[pl_sc,pl_fwc],{'Septal','Free wall'},'Location','southwest');
legend(app.CurvatureView,"boxoff");
hold(app.CurvatureView,'off');
hold(app.CurvatureRatioView,'off');

if strcmpi(app.PointsforcirclefittingDropDown.Value,'Auto') % draw curvature area only for auto mode
    % curvatur area
    % plot
    plot(app.CurvatureAreaView,ntemp(1):1:ntemp(2),app.CurvatureArea(:,areaApproach,1),'mo');
    hold(app.CurvatureAreaView,'on');
    y = spline(ntemp(1):1:ntemp(2),app.CurvatureArea(:,areaApproach,1),ntemp(1):0.1:ntemp(2));
    pl_ca_pl = plot(app.CurvatureAreaView,ntemp(1):0.1:ntemp(2),y,'m-');

    plot(app.CurvatureAreaView,ntemp(1):1:ntemp(2),app.CurvatureArea(:,areaApproach,2),'co');
    y = spline(ntemp(1):1:ntemp(2),app.CurvatureArea(:,areaApproach,2),ntemp(1):0.1:ntemp(2));
    pl_ca_mi = plot(app.CurvatureAreaView,ntemp(1):0.1:ntemp(2),y,'c-');

    % current time
    xline(app.CurvatureAreaView,app.TimeStepSpinner.Value);
    yline(app.CurvatureAreaView,0);

    % figure legends
    legend(app.CurvatureAreaView,[pl_ca_pl,pl_ca_mi],{'convex to RV','Convex to LV'},'Location','southwest');
    legend(app.CurvatureAreaView,"boxoff");
    hold(app.CurvatureAreaView,'off');
end
end
