
function ComputeCurvatureArea(app,rad)

currentTimeStep = app.TimeStepSpinner.Value;

t1arch          = app.ArchPoints{currentTimeStep,2};
cx              = app.ApproxCircleCenter_rvcurve(currentTimeStep,1);
cy              = app.ApproxCircleCenter_rvcurve(currentTimeStep,2);
refPoints(1,:)  = app.RefPoints(currentTimeStep,1,:);
refPoints(2,:)  = app.RefPoints(currentTimeStep,2,:);

step_integral = size(t1arch,1);

% Compute LV area for normalization
LVepi = squeeze(app.CoordContours(currentTimeStep,1,:,:));
LVarea = polyarea(LVepi(:,1),LVepi(:,2));

if t1arch(1,2) > t1arch(end,2)
    t1arch = flip(t1arch,1);
end

% line segment (approach 1)
[areaplus,areaminus] = get_linebasedArea(app,t1arch,refPoints,step_integral);

%             if refPoints(1,1) == refPoints(2,1) % if the line to create is x = const.
%                 xq = repmat(refPoints(1,1),[1,step_integral]);
%                 yq = refPoints(1,2) :(refPoints(2,2)-refPoints(1,2))/(step_integral -1) : refPoints(2,2);
%             else                                % if the line to create is y = ax
%                 xq = refPoints(1,1) :(refPoints(2,1)-refPoints(1,1))/(step_integral -1) : refPoints(2,1);
%                 yq = interp1([refPoints(1,1) refPoints(2,1)],[refPoints(1,2) refPoints(2,2)],xq,'linear');
%             end
%
%             linsegq = [xq;yq]';
%
%             % interpolate the arch with the same steps
% %             tarch   = 1:size(t1arch,1);
% %             tarchq  = 1:(size(t1arch,2)-1)/(step_integral-1):size(t1arch,2);
% %             t1archq(1,:) = spline(tarch,t1arch(:,1),tarchq);
% %             t1archq(2,:) = spline(tarch,t1arch(:,2),tarchq);
%
%             areaplus  = 0;
%             areaminus = 0;
%
%             % compute area (cross product)
%             for i = 1 : size(linsegq,1)-1
%                 v2 = t1arch(i  ,:) - linsegq(i+1,:);
%                 v1 = t1arch(i+1,:) - linsegq(i  ,:);
%
%                 area = 0.5*(v1(1)*v2(2)-v1(2)*v2(1));
%                 if area >= 0
%                     areaplus  = areaplus + area;
%                 else
%                     areaminus = areaminus + area;
%                 end
%             end

app.CurvatureArea(currentTimeStep,1,1) = areaplus;
app.CurvatureArea(currentTimeStep,1,2) = areaminus;
app.NormCurvatureArea(currentTimeStep,1,1) = areaplus/LVarea;
app.NormCurvatureArea(currentTimeStep,1,2) = areaminus/LVarea;

% compute the arch of the approximated circle (approach 2)
ang = 0:1/(step_integral-1):2*pi;
circPoints(1,:) = cx + rad*cos(ang);
circPoints(2,:) = cy + rad*sin(ang);

dist1 = sqrt((circPoints(1,:) - refPoints(1,1)).^2 + (circPoints(2,:) - refPoints(1,2)).^2);
dist2 = sqrt((circPoints(1,:) - refPoints(2,1)).^2 + (circPoints(2,:) - refPoints(2,2)).^2);

[~,minind1] = min(dist1);
[~,minind2] = min(dist2);

clear circPoints

%if (minind2 - minind1) < 0
ang_arch = ang(minind1):(ang(minind2)-ang(minind1))/(step_integral -1):ang(minind2);
%else
%    ang_arch = ang(minind2):(ang(minind1)-ang(minind2))/(step_integral -1):ang(minind1);
%end

circPoints(:,1) = cx + rad*cos(ang_arch);
circPoints(:,2) = cy + rad*sin(ang_arch);

areaplus  = 0;
areaminus = 0;
% compute area (cross product)
for i = 1 : size(circPoints,1)-1
    v2 = t1arch(i  ,:) - circPoints(i+1,:);
    v1 = t1arch(i+1,:) - circPoints(i  ,:);

    area = 0.5*(v1(1)*v2(2)-v1(2)*v2(1));
    if area >= 0
        areaplus  = areaplus + area;
    else
        areaminus = areaminus + area;
    end
end

app.CurvatureArea(currentTimeStep,2,1) = areaplus;
app.CurvatureArea(currentTimeStep,2,2) = areaminus;
app.NormCurvatureArea(currentTimeStep,2,1) = areaplus/LVarea;
app.NormCurvatureArea(currentTimeStep,2,2) = areaminus/LVarea;

end
