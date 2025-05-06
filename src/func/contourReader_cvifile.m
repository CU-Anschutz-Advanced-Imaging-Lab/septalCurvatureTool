function contourReader_cvifile(app,filename,pathToFile)
% File select and open
if nargin < 2
    if ispc
        [filename, pathToFile] = uigetfile('','Select your Circle output file (.cvi42wsx).','*.cvi42wsx');
    else
        [filename, pathToFile] = uigetfile('*');
    end
end
fid = fopen(fullfile(pathToFile, filename));
app.messagetxt.Value = 'Loading the cvi file....';
pause(0.05);

ilinetotal    = 0;
if_in_contour_part = 0;
if_read = zeros(1,5);
if_done = zeros(1,5);
iline   = zeros(1,5);
icount  = zeros(1,5) + 1;
if_got_subpix  = 0;
if_got_pixsize = 0;
t_count = 0;

% read lines
while ~feof(fid)
    ilinetotal       = ilinetotal + 1;
    line = fgetl(fid);
    if ~contains(line,'!--end of') && any(cell2mat(cellfun(@(x) contains(line,x),app.SOPInstanceUID,'UniformOutput',false)))
        if_in_contour_part = 1;
        startpos = strfind(line,'Hash:key=');
        endpos   = strfind(line,'Hash:count');
        SOP_cvi = line(startpos+length('Hash:key=')+1:endpos-3);
        timepoint = find(contains(app.SOPInstanceUID,SOP_cvi));
        t_count = t_count + 1;
    end

    if if_in_contour_part
        % search for end line
        if contains(line,'!--end of') && contains(line,SOP_cvi)
            if ~all(if_done)
                warning(['Some contour data may be missing for time step #',num2str(timepoint,'%0d')]);
            end
            if_in_contour_part = 0;
            if_done(1:end) = 0;
            continue;
        end

        if if_got_subpix==0 && contains(line,'SubpixelResolution')
            txtstr = strsplit(line,{'>','<'});
            app.SubPixRes = str2double(txtstr{3}); % assume all images have the same subpixel resolution
            if_got_subpix = 1;
        end

        if if_got_pixsize == 0 && contains(line,'PixelSize')
            line = fgetl(fid);
            txtstr = strsplit(line,{'>','<'});
            app.PixelSize(1) = str2double(txtstr{3});

            line = fgetl(fid);
            txtstr = strsplit(line,{'>','<'});
            app.PixelSize(2) = str2double(txtstr{3});

            if_got_pixsize = 1;
        end

        % beginning statements
        if contains(line,'key="sacardialRefPoint"')
            if_read(1) = 1;
            iline(1)   = 1;
        end

        if contains(line,'key="sacardialInferiorRefPoint"')
            if_read(2) = 1;
            iline(2)   = 1;
        end

        if contains(line,'key="saepicardialContour"')
            if_read(3) = 1;
            iline(3)   = 1;
        end

        if contains(line,'key="sarvendocardialContour"')
            if_read(4) = 1;
            iline(4)   = 1;
        end

        if contains(line,'key="saendocardialContour"')
            if_read(5) = 1;
            iline(5)   = 1;
        end

        % end statement
        if contains(line,"end of sacardialRefPoint")
            if_read(1) = 0;
            if_done(1) = 1;
            icount(1)  = 1;
        end

        if contains(line,"end of sacardialInferiorRefPoint")
            if_read(2) = 0;
            if_done(2) = 1;
            icount(2)  = 1;
        end

        if contains(line,"end of saepicardialContour")
            if_read(3) = 0;
            if_done(3) = 1;
            icount(3)  = 1;
        end

        if contains(line,"end of sarvendocardialContour")
            if_read(4) = 0;
            if_done(4) = 1;
            icount(4)  = 1;
        end

        if contains(line,"end of saendocardialContour")
            if_read(5) = 0;
            if_done(5) = 1;
            icount(5)  = 1;
        end


        % read lines
        if if_read(1) == 1
            if contains(line,'Point:x') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                app.RefPoints(timepoint,1,1) = str2double(txtstr{3});
            end
            if contains(line,'Point:y') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                app.RefPoints(timepoint,1,2) = str2double(txtstr{3});
            end
        end

        if if_read(2) == 1
            if contains(line,'Point:x') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                app.RefPoints(timepoint,2,1) = str2double(txtstr{3});
            end
            if contains(line,'Point:y') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                app.RefPoints(timepoint,2,2) = str2double(txtstr{3});
            end
        end

        if if_read(3) == 1
            if contains(line,'Point:x') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                coord_contours(timepoint,1,icount(3),1) = str2double(txtstr{3});
            end
            if contains(line,'Point:y') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                coord_contours(timepoint,1,icount(3),2) = str2double(txtstr{3});
                icount(3) = icount(3) + 1;
            end
        end

        if if_read(4) == 1
            if contains(line,'Point:x') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                coord_contours(timepoint,2,icount(4),1) = str2double(txtstr{3});
            end
            if contains(line,'Point:y') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                coord_contours(timepoint,2,icount(4),2) = str2double(txtstr{3});
                icount(4) = icount(4) + 1;
            end
        end

        if if_read(5) == 1
            if contains(line,'Point:x') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                coord_contours(timepoint,3,icount(5),1) = str2double(txtstr{3});
            end
            if contains(line,'Point:y') % x coordinate
                txtstr = strsplit(line,{'>','<'});
                coord_contours(timepoint,3,icount(5),2) = str2double(txtstr{3});
                icount(5) = icount(5) + 1;
            end
        end


    end
end
if length(app.SOPInstanceUID) ~= t_count
    warning(['The number of DICOM files [',num2str(length(app.SOPInstanceUID),'%0d'),'] is different from the number of contours [',num2str(t_count,'%0d'),'].']);
end
fclose(fid);

% scaling
coord_contours(:,:,:,1) = coord_contours(:,:,:,1)/app.SubPixRes*app.PixelSize(1);
coord_contours(:,:,:,2) = coord_contours(:,:,:,2)/app.SubPixRes*app.PixelSize(2);
app.CoordContours = coord_contours;

app.RefPoints(:,:,1) = app.RefPoints(:,:,1)/app.SubPixRes*app.PixelSize(1);
app.RefPoints(:,:,2) = app.RefPoints(:,:,2)/app.SubPixRes*app.PixelSize(2);

app.messagetxt.Value = 'cvi file loaded.';
pause(0.05);

end
