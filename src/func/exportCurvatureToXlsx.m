function exportCurvatureToXlsx(app,ptFolderName,xlpath,xlname,ip)
if nargin == 1
    saveOpt =  questdlg("Save to a new file or to existing file?","Save options","New file","Existing file","New file");
    switch saveOpt
        case "New file"
            if_addToExist = 0;
        case "Existing file"
            if_addToExist = 1;
    end

    prompt = {['Enter a name to spacify this patient (If you select "Existing file" and use an already existing sheet name, ' ...
        'the result will be appended to the bottom of that sheet, not creating a new sheet.']};
    dlgtitle = "Export file name dialog";
    definput = {app.ptsdirname};
    answer = inputdlg(prompt,dlgtitle,1,definput);
end

if nargin == 5
    if_addToExist = 1;
    answer{1} = ptFolderName;
end

if nargin ~= 1 && nargin ~= 5
    error('Number of input argments should be 1 or 4');
end

if strcmpi(app.PointsforcirclefittingDropDown.Value,'Auto')
    mode = 1;
else
    mode = 2;
end
% create a table
Time_Step = [1:app.TimeStepSpinner.Limits(2)]';
Septal_Curvature      = app.CurvatureSeptum(:,mode);
Free_Wall_Curvature   = app.CurvatureFreeWall(:,mode);
Curvature_Ratio       = app.CurvatureRatio;
if mode == 1
    Curvature_Area_Linebase_plus   =app.CurvatureArea(:,1,1);
    Curvature_Area_Linebase_minus  =app.CurvatureArea(:,1,2);
    Curvature_Area_Curvebase_plus  =app.CurvatureArea(:,2,1);
    Curvature_Area_Curvebase_minus =app.CurvatureArea(:,2,2);
    NormCurvature_Area_Linebase_plus   =app.NormCurvatureArea(:,1,1);
    NormCurvature_Area_Linebase_minus  =app.NormCurvatureArea(:,1,2);
    NormCurvature_Area_Curvebase_plus  =app.NormCurvatureArea(:,2,1);
    NormCurvature_Area_Curvebase_minus =app.NormCurvatureArea(:,2,2);

    output = table(Time_Step,Septal_Curvature,Free_Wall_Curvature,Curvature_Ratio,...
        Curvature_Area_Linebase_plus,Curvature_Area_Linebase_minus,...
        Curvature_Area_Curvebase_plus,Curvature_Area_Curvebase_minus,...
        NormCurvature_Area_Linebase_plus,NormCurvature_Area_Linebase_minus,...
        NormCurvature_Area_Curvebase_plus,NormCurvature_Area_Curvebase_minus);
else
    output = table(Time_Step,Septal_Curvature,Free_Wall_Curvature,Curvature_Ratio);
end

if if_addToExist == 0
    saveloc = uigetdir(pwd,"Choose location to save excel file.");
    savefile = [answer{1},'.xlsx'];
    writetable(output,fullfile(saveloc,savefile),'Sheet',answer{1});
else
    if nargin == 1 % individual
        [savefile,saveloc] = uigetfile("","Choose a spreadsheet to add this patient.");
    end
    if nargin == 5 % batch
        savefile = xlname;
        saveloc  = xlpath;
    end
    writetable(output,fullfile(saveloc,savefile),'Sheet',answer{1},'WriteMode',"append");
end

if nargin == 5 % statistics
    stat{1,1} = answer{1};
    stat{1,2} = sum(Curvature_Ratio);
    [~,indmin] = min(Curvature_Ratio);
    Curvature_Ratio_repeat = repmat(Curvature_Ratio,3,1);
    stat{1,3} = mean(Curvature_Ratio_repeat(length(Curvature_Ratio)+indmin-1:length(Curvature_Ratio)+indmin+1));
    stat{1,4} = mean(Curvature_Ratio_repeat(length(Curvature_Ratio)+indmin-2:length(Curvature_Ratio)+indmin+2));
    stat{1,5} = mean(Curvature_Ratio_repeat(length(Curvature_Ratio)+indmin-3:length(Curvature_Ratio)+indmin+3));
    stat{1,6} = min(Curvature_Ratio);
    stat{1,7} = max(Curvature_Ratio);
    stat{1,8} = mean(Curvature_Ratio);
    if mode == 1
        stat{1,9} = sum(Curvature_Area_Linebase_plus);
        stat{1,10} = min(Curvature_Area_Linebase_plus);
        stat{1,11} = max(Curvature_Area_Linebase_plus);
        stat{1,12} = mean(Curvature_Area_Linebase_plus);
        stat{1,13} = sum(Curvature_Area_Linebase_minus);
        stat{1,14} = min(Curvature_Area_Linebase_minus);
        stat{1,15} = max(Curvature_Area_Linebase_minus);
        stat{1,16} = mean(Curvature_Area_Linebase_minus);
        stat{1,17} = sum(Curvature_Area_Curvebase_plus);
        stat{1,18} = min(Curvature_Area_Curvebase_plus);
        stat{1,19} = max(Curvature_Area_Curvebase_plus);
        stat{1,20} = mean(Curvature_Area_Curvebase_plus);
        stat{1,21} = sum(Curvature_Area_Curvebase_minus);
        stat{1,22} = min(Curvature_Area_Curvebase_minus);
        stat{1,23} = max(Curvature_Area_Curvebase_minus);
        stat{1,24} = mean(Curvature_Area_Curvebase_minus);
        stat{1,25} = sum(NormCurvature_Area_Linebase_plus);
        stat{1,26} = min(NormCurvature_Area_Linebase_plus);
        stat{1,27} = max(NormCurvature_Area_Linebase_plus);
        stat{1,28} = mean(NormCurvature_Area_Linebase_plus);
        stat{1,29} = sum(NormCurvature_Area_Linebase_minus);
        stat{1,30} = min(NormCurvature_Area_Linebase_minus);
        stat{1,31} = max(NormCurvature_Area_Linebase_minus);
        stat{1,32} = mean(NormCurvature_Area_Linebase_minus);
        stat{1,33} = sum(NormCurvature_Area_Curvebase_plus);
        stat{1,34} = min(NormCurvature_Area_Curvebase_plus);
        stat{1,35} = max(NormCurvature_Area_Curvebase_plus);
        stat{1,36} = mean(NormCurvature_Area_Curvebase_plus);
        stat{1,37} = sum(NormCurvature_Area_Curvebase_minus);
        stat{1,38} = min(NormCurvature_Area_Curvebase_minus);
        stat{1,39} = max(NormCurvature_Area_Curvebase_minus);
        stat{1,40} = mean(NormCurvature_Area_Curvebase_minus);

        rangechr = ['A',num2str(ip+1),':','AK',num2str(ip+1)];
    else
        rangechr = ['A',num2str(ip+1),':','E',num2str(ip+1)];
    end
    writecell(stat,fullfile(xlpath,xlname),'Sheet','Summary','Range',rangechr)
end

end
