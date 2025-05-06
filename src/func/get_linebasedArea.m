
function [areaplus,areaminus] = get_linebasedArea(app,t1arch,refPoints,step_integral)

if refPoints(1,1) == refPoints(2,1) % if the line to create is x = const.
    xq = repmat(refPoints(1,1),[1,step_integral]);
    yq = refPoints(1,2) :(refPoints(2,2)-refPoints(1,2))/(step_integral -1) : refPoints(2,2);
else                                % if the line to create is y = ax
    xq = refPoints(1,1) :(refPoints(2,1)-refPoints(1,1))/(step_integral -1) : refPoints(2,1);
    yq = interp1([refPoints(1,1) refPoints(2,1)],[refPoints(1,2) refPoints(2,2)],xq,'linear');
end

linsegq = [xq;yq]';

% interpolate the arch with the same steps
%             tarch   = 1:size(t1arch,1);
%             tarchq  = 1:(size(t1arch,2)-1)/(step_integral-1):size(t1arch,2);
%             t1archq(1,:) = spline(tarch,t1arch(:,1),tarchq);
%             t1archq(2,:) = spline(tarch,t1arch(:,2),tarchq);

areaplus  = 0;
areaminus = 0;

% compute area (cross product)
for i = 1 : size(linsegq,1)-1
    v2 = t1arch(i  ,:) - linsegq(i+1,:);
    v1 = t1arch(i+1,:) - linsegq(i  ,:);

    area = 0.5*(v1(1)*v2(2)-v1(2)*v2(1));
    if area >= 0
        areaplus  = areaplus + area;
    else
        areaminus = areaminus + area;
    end
end
end
