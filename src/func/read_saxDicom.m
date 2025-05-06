
function read_saxDicom(app, dirDcm)
% read DICOM data to re-arrange temporal contours.
% with assumption that Dicom files have correct temporal orders.
% Dicom and cvi output can be linked by SOP Instance UID.
if nargin < 2
    dirDcm = uigetdir('','Select a folder that includes dicom files used for contour delineation');
    [~ ,app.ptsdirname, ~] = fileparts(fileparts(dirDcm));
end
dirDcmFiles = dir(dirDcm);
dirDcmFiles = dirDcmFiles(~ismember({dirDcmFiles.name},{'.','..','.DS_Store'}));
img = cell(length(dirDcmFiles),1);
tag = cell(length(dirDcmFiles),1);
cnt = 1;
for i = 1 : length(dirDcmFiles)
    tag                   = dicominfo(fullfile(dirDcmFiles(i).folder,dirDcmFiles(i).name),'dictionary','dicom-dict_philips.txt');
    %                 if ~any(contains(SOP_cvi,tag.SOPInstanceUID(end-9:end)))
    %                     continue;
    %                 end
    app.SAXimg{cnt}         = dicomread(fullfile(dirDcmFiles(i).folder,dirDcmFiles(i).name));
    app.SOPInstanceUID{cnt} = tag.SOPInstanceUID;
    app.PixelSpacing      = tag.PixelSpacing;
    cnt = cnt + 1;
    app.messagetxt.Value = ['Reading SAX dicom...(',num2str(ceil(i/length(dirDcmFiles)*100)),'%)'];
    pause(0.01);
end

%             % use SOPInstanceUID to reorder temporal dataf
%             indtotal = zeros(size(app.SOPInstanceUID));
%             if length(SOP_cvi) ~= length(app.SOPInstanceUID)
%                 for i = 1 : size(SOP_cvi,1)
%                     ind = contains(app.SOPInstanceUID,SOP_cvi{i});
%                     indtotal = indtotal + ind;
%                 end
%                 app.SOPInstanceUID = app.SOPInstanceUID(logical(indtotal));
%                 app.SAXimg = app.SAXimg(logical(indtotal));
%             end

%             for i = 1 : size(SOP_cvi,1)
%                 tstep = contains(SOP_cvi,app.SOPInstanceUID{i}(end-9:end));
%                 I(i,1) = find(tstep);
%             end
%
%             % reorder temporal data
%             app.CoordContours = app.CoordContours(I,:,:,:);
%             app.RefPoints = app.RefPoints(I,:,:);

end
