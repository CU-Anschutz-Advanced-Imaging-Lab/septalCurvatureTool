
function rinv = ComputeCurvature(app,points, i, j)
hold(app.ContourView,'off');

currentTimeStep = app.TimeStepSpinner.Value;
tmp1  = squeeze(squeeze(app.CoordContours(currentTimeStep,i,:,:))); % use RV contour
tmp2  = squeeze(squeeze(app.CoordContours(currentTimeStep,j,:,:))); % use RV contour
LVend = squeeze(squeeze(app.CoordContours(currentTimeStep,3,:,:)));
tmp1(tmp1==0) = [];
tmp1 = reshape(tmp1,[],2);
tmp2(tmp2==0) = [];
tmp2 = reshape(tmp2,[],2);
LVend(LVend==0) = [];
LVend = reshape(LVend,[],2);
[~,minind1] = min(sqrt((tmp1(:,1)-points{1}(1,1)).^2+(tmp1(:,2)-points{1}(1,2)).^2));
[~,minind2] = min(sqrt((tmp1(:,1)-points{2}(1,1)).^2+(tmp1(:,2)-points{2}(1,2)).^2));
t1cen       = mean(tmp1,1);
t2cen       = mean(tmp2,1);
if minind1 < minind2
    t1arch1 = tmp1(minind1:minind2,:);
    t1arch2 = [tmp1(minind2:end,:);tmp1(1:minind1,:)];
else
    t1arch1 = tmp1(minind2:minind1,:);
    t1arch2 = [tmp1(minind1:end,:);tmp1(1:minind2,:)];
end
t1arch1cen  = mean(t1arch1,1);
t1arch2cen  = mean(t1arch2,1);
if i == 2 % septal curvature
    if norm(t2cen-t1arch1cen) < norm(t2cen-t1arch2cen)
        t1arch = t1arch1;
    else
        t1arch = t1arch2;
    end

    % if septal curvature, use mid points between RVendo and LVendo for p3
    [~,ind_1  ] = min(sqrt((LVend(:,1)-t1arch(1,1)).^2+(LVend(:,2)-t1arch(1,2)).^2));
    %[~,ind_mid] = min(sqrt((LVend(:,1)-t1arch(floor(end/2),1)).^2+(LVend(:,2)-t1arch(floor(end/2),2)).^2));
    [~,ind_end] = min(sqrt((LVend(:,1)-t1arch(end,1)).^2+(LVend(:,2)-t1arch(end,2)).^2));
    if ind_1 < ind_end
        LVendoCurveSeg1 = LVend(ind_1:ind_end,:);
        LVendoCurveSeg2 = [LVend(ind_end:end,:);LVend(1:ind_1,:)];
    else
        LVendoCurveSeg1 = LVend(ind_end:ind_1,:);
        LVendoCurveSeg2 = [LVend(ind_1:end,:);LVend(1:ind_end,:)];
    end
    if norm(t1cen-mean(LVendoCurveSeg1,1)) < norm(t1cen-mean(LVendoCurveSeg2,1))
        LVendoSeptalSeg = LVendoCurveSeg1;
    else
        LVendoSeptalSeg = LVendoCurveSeg2;
    end
    % smooth (optional)
    %LVendoSeptalSeg_org = LVendoSeptalSeg;
    %t1arch          = smoothdata(smoothdata(t1arch,1,"gaussian"),1,"gaussian");
    %LVendoSeptalSeg = smoothdata(smoothdata(LVendoSeptalSeg,1,"gaussian"),1,"gaussian");
    % obtain the third point to use for least square fit. Select
    % the most distant point from the line (LVendoSeptalSeg(1),LVendoSeptalSeg(end))
    a = (LVendoSeptalSeg(1,2) - LVendoSeptalSeg(end,2))/(LVendoSeptalSeg(1,1) - LVendoSeptalSeg(end,1));
    c = t1cen(1,2) - a*t1cen(1,1); % get a line y = ax + c that passes RV center
    c_org = LVendoSeptalSeg(1,2) - a*LVendoSeptalSeg(1,1); % get a line y = ax + c that passes RV center
    lowlim = floor(size(LVendoSeptalSeg,1)*0.15);
    highlim = ceil(size(LVendoSeptalSeg,1)*0.85);
    if isinf(a) % vertical line
        dist = abs(LVendoSeptalSeg(:,1) - t1cen(1,1));
        dist_for_weight = abs(LVendoSeptalSeg(:,1) - LVendoSeptalSeg(1,1));
        line_bw_refpts(1:101,1) = t1arch(1,1);
        line_bw_refpts(:,2) =  t1arch(1,2):(t1arch(end,2) - t1arch(1,2))/100:t1arch(end,2);
    else
        dist = abs(a*LVendoSeptalSeg(:,1)-LVendoSeptalSeg(:,2)+c)/sqrt(a^2+1);
        dist_for_weight = abs(a*LVendoSeptalSeg(:,1)-LVendoSeptalSeg(:,2)+c_org)/sqrt(a^2+1);
        line_bw_refpts(:,1) = LVendoSeptalSeg(1,1):(LVendoSeptalSeg(end,1) - LVendoSeptalSeg(1,1))/100:LVendoSeptalSeg(end,1);
        line_bw_refpts(:,2) = line_bw_refpts(:,1)*a+c_org;
    end
    if currentTimeStep == 1
        app.weightParam = max(dist_for_weight);
    end

    for iseg = 1 : size(LVendoSeptalSeg,1)
        [~, id] = min(sqrt((LVendoSeptalSeg(iseg,1)-line_bw_refpts(:,1)).^2 + (LVendoSeptalSeg(iseg,2)-line_bw_refpts(:,2)).^2));
        vec = LVendoSeptalSeg(iseg,:) - line_bw_refpts(id(1),:);
        if dot(t2cen-t1cen,vec) > 0
            sign_dist(iseg,1) = -1;
        else
            sign_dist(iseg,1) =  1;
        end
    end

    window = zeros(size(LVendoSeptalSeg,1),1);
    window(lowlim:highlim) = 1;
    tf_concav = findConcaveShape(app,LVendoSeptalSeg,a,window,dist);
    if any(~tf_concav.*window)
        mask = ~tf_concav.*window;
        mask(mask==0) = Inf;
        [~,ind_bowRV] = min(dist.*mask);
        %weight_lsf_bowRV = dist_for_weight(ind_bowRV)/app.weightParam;
        weight_lsf_bowRV = 1;
    else
        ind_bowRV = [];
    end
    if any(tf_concav.*window)
        mask = tf_concav.*window;
        [~,ind_bowLV] = max(dist.*mask);
        weight_lsf_bowLV = 1 - sign_dist(ind_bowLV)*(dist_for_weight(ind_bowLV)/app.weightParam);
        if weight_lsf_bowLV > 1
            weight_lsf_bowLV = 1;
            weight_lsf_bowRV = 0;
        else
            weight_lsf_bowRV = 1-weight_lsf_bowLV;
        end
    else
        ind_bowLV = [];
        %    ind_mid = floor(size(LVendoSeptalSeg,1)/2);
    end
    %if ind_mid/size(LVendoSeptalSeg,1)<0.3 || ind_mid/size(LVendoSeptalSeg,1)>0.7
    %    ind_mid = floor(size(LVendoSeptalSeg,1)/2);
    %end

    % find the corresponding RV endo coordinates for weighted average
    weight = 0.6;
    if ~isempty(ind_bowLV)
        [~,ind_mid_arch] = min(sqrt((t1arch(:,1)-LVendoSeptalSeg(ind_bowLV,1)).^2+(t1arch(:,2)-LVendoSeptalSeg(ind_bowLV,2)).^2));
        p2 = weight*LVendoSeptalSeg(ind_bowLV,:) + (1-weight)*t1arch(ind_mid_arch,:);
    end
    if ~isempty(ind_bowRV)
        [~,ind_mid_arch2] = min(sqrt((t1arch(:,1)-LVendoSeptalSeg(ind_bowRV,1)).^2+(t1arch(:,2)-LVendoSeptalSeg(ind_bowRV,2)).^2));
        p2_2 = weight*LVendoSeptalSeg(ind_bowRV,:) + (1-weight)*t1arch(ind_mid_arch2,:);
    end
    % obtain an (weighted) setpal midline
    if (ind_1 < ind_end && norm(t1cen-mean(LVendoCurveSeg1,1)) < norm(t1cen-mean(LVendoCurveSeg2,1))) || (ind_1 > ind_end && norm(t1cen-mean(LVendoCurveSeg1,1)) > norm(t1cen-mean(LVendoCurveSeg2,1)))
        p1 = weight*LVendoSeptalSeg(1      ,:) + (1-weight)*t1arch(1           ,:);
        %p2 = weight*LVendoSeptalSeg(ind_mid,:) + (1-weight)*t1arch(ind_mid_arch,:);
        p3 = weight*LVendoSeptalSeg(end    ,:) + (1-weight)*t1arch(end         ,:);
    else
        p1 = weight*LVendoSeptalSeg(end    ,:) + (1-weight)*t1arch(1           ,:);
        %p2 = weight*LVendoSeptalSeg(ind_mid,:) + (1-weight)*t1arch(ind_mid_arch,:);
        p3 = weight*LVendoSeptalSeg(1      ,:) + (1-weight)*t1arch(end         ,:);
    end
    % save ref points
    app.RefPoints_midSepWall(currentTimeStep,1,:) = p1;
    app.RefPoints_midSepWall(currentTimeStep,2,:) = p3;
    % 3 point approximation
    if ~isempty(ind_bowRV) && ~isempty(ind_bowLV)
        weight_lsf = [1,weight_lsf_bowLV,weight_lsf_bowRV,1];
        %[ cx, cy, rinv ] = CircleFitting(app,[p1(1);p2(1);p2_2(1);p3(1)],[p1(2);p2(2);p2_2(2);p3(2)]);
        [ cx, cy, rinv ] = CircleFitting_weighted(app,[p1(1);p2(1);p2_2(1);p3(1)],[p1(2);p2(2);p2_2(2);p3(2)],weight_lsf);
    elseif ~isempty(ind_bowLV)
        weight_lsf = [1,weight_lsf_bowLV,1];
        %[ cx, cy, rinv ] = CircleFitting(app,[p1(1);p2(1);p3(1)],[p1(2);p2(2);p3(2)]);
        [ cx, cy, rinv ] = CircleFitting_weighted(app,[p1(1);p2(1);p3(1)],[p1(2);p2(2);p3(2)],weight_lsf);
    else
        weight_lsf = [1,weight_lsf_bowRV,1];
        %[ cx, cy, rinv ] = CircleFitting(app,[p1(1);p2_2(1);p3(1)],[p1(2);p2_2(2);p3(2)]);
        [ cx, cy, rinv ] = CircleFitting_weighted(app,[p1(1);p2_2(1);p3(1)],[p1(2);p2_2(2);p3(2)],weight_lsf);
    end

    p1 = t1arch(1,:);
    p2 = t1arch(floor(end/2),:);
    p3 = t1arch(end,:);
    % 3 point approximation
    [ cx_rvcurve, cy_rvcurve, rinv_rvcurve] = CircleFitting(app,[p1(1);p2(1);p3(1)],[p1(2);p2(2);p3(2)]);
    if cx < mean(t1arch(:,1)) && i == 2 % only for septal curvature
        rinv_rvcurve = -rinv_rvcurve;
    end
    app.ApproxCircleCenter_rvcurve(currentTimeStep,:) = [cx_rvcurve cy_rvcurve];
else % free wall curvature
    if norm(t2cen-t1arch1cen) < norm(t2cen-t1arch2cen)
        t1arch = t1arch2;
    else
        t1arch = t1arch1;
    end
    p1 = t1arch(1,:);
    p2 = t1arch(floor(end/2),:);
    p3 = t1arch(end,:);
    % 3 point approximation
    [ cx, cy, rinv ] = CircleFitting(app,[p1(1);p2(1);p3(1)],[p1(2);p2(2);p3(2)]);
end
% all points
%[ cx, cy, rinv ] = CircleFitting(app,t1arch(:,1),t1arch(:,2));
% 3 point approximation
%[ cx, cy, rinv ] = CircleFitting(app,[p1(1);p2(1);p3(1)],[p1(2);p2(2);p3(2)]);

if cx < mean(t1arch(:,1)) && i == 2 % only for septal curvature
    rinv = -rinv;
end

app.ArchPoints{currentTimeStep,i} = t1arch;
app.ApproxCircleCenter(currentTimeStep,i,1) = cx;
app.ApproxCircleCenter(currentTimeStep,i,2) = cy;

if i == 2
    ComputeCurvatureArea(app,1/rinv_rvcurve);
end

end
