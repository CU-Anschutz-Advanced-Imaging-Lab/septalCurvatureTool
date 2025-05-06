function saveManualpoints(app,saveDir)
if ~isempty(app.Points)
    if nargin < 2
        dirloc = uigetdir('','Select directory to save points.');
    else
        dirloc = saveDir;
    end
    savefilename = fullfile(dirloc,[app.ptsdirname,'_manualPoints.csv']);
    allpoints_xy = [];
    for t = 1 : app.TimeStepSpinner.Limits(2)
        allpoints_xy_t = [app.Points{1,t};app.Points{2,t}];
        allpoints_xy_t = reshape(allpoints_xy_t',1,[]);
        allpoints_xy = [allpoints_xy;allpoints_xy_t];
    end
    timeStep = 1 : app.TimeStepSpinner.Limits(2);
    T = array2table(allpoints_xy);
    T.Properties.VariableNames = {'Freewall_x1','Freewall_y1','Freewall_x2','Freewall_y2','Freewall_x3','Freewall_y3','Septal_x1','Septal_y1','Septal_x2','Septal_y2','Septal_x3','Septal_y3'};
    T = addvars(T,timeStep','Before',"Freewall_x1",'NewVariableNames','TimeSteps');
    writetable(T,savefilename);
    app.messagetxt.Value = 'Manual Point saved.';
else
    app.messagetxt.FontColor = 'r';
    app.messagetxt.Value = 'Manual points do not exist.';
end
end

