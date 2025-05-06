
function GetSeptalCurvature_allPhases(app)
if strcmp(app.ReferencepointsDropDown.Value, 'Automatic')
    refPointSep = ComputeSeptalRefPoints(app);
end
currentTimeStep = app.TimeStepSpinner.Value;
for t = 1 : size(app.CoordContours,1)
    app.TimeStepSpinner.Value = t;
    % for septal
    if strcmp(app.ReferencepointsDropDown.Value, 'Automatic')
        points{1}(1,:) = refPointSep(t,1,:);   % method 2: use automated hinge point detection
        points{2}(1,:) = refPointSep(t,2,:);
    else
        points{1}(1,:) = app.RefPoints(t,1,:);  % method 1: use user-specified point (on cvi42)
        points{2}(1,:) = app.RefPoints(t,2,:);
    end
    app.CurvatureSeptum(t,1) = ComputeCurvature(app,points,2,1);
end
app.TimeStepSpinner.Value = currentTimeStep;
drawContours(app,currentTimeStep);
updateCurvaturePlot(app,app.CurvatureSeptum(:,1),app.CurvatureFreeWall(:,1));
end
