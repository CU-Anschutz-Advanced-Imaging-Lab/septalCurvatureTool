function loadManualpoints_computeCurvature(app,mptsFileLoc)
if nargin < 2
    if ispc
        [filename, pathToFile] = uigetfile('','Select the manualPoint file.','*.csv');
    else
        [filename, pathToFile] = uigetfile('*');
    end
else % batch
    [pathToFile,filename,~] = fileparts(mptsFileLoc);
end

T = readtable(fullfile(pathToFile,filename));
allpoints_xy = table2array(T);
allpoints_xy(:,1) = [];
for t = 1 : app.TimeStepSpinner.Limits(2)
    allpoints_xy_t = allpoints_xy(t,:);
    allpoints_xy_t = reshape(allpoints_xy_t,2,[])';
    app.Points{1,t} = allpoints_xy_t(1:3,:);
    app.Points{2,t} = allpoints_xy_t(4:6,:);
end
drawManualCurves(app,app.TimeStepSpinner.Value);
app.registrationDone = true;
app.PointsforcirclefittingDropDown.Value = 'Manual';
app.messagetxt.Value = 'Manual points loaded.';
set(app.TimeStepSpinner,'Enable','on');
% compute curvature
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
updateCurvaturePlot(app,app.CurvatureSeptum(:,2),app.CurvatureFreeWall(:,2));
end
