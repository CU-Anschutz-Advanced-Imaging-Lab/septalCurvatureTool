
function refPointFW = ComputeFreeWallRefPoints(app,deg)
theta = pi/180 * deg;
for t = 1 : app.TimeStepSpinner.Limits(2)
    tmp1 = squeeze(squeeze(app.CoordContours(t,1,:,:)));
    tmp2 = squeeze(squeeze(app.CoordContours(t,2,:,:)));
    tmp1(tmp1==0) = [];
    tmp1 = reshape(tmp1,[],2);
    tmp2(tmp2==0) = [];
    tmp2 = reshape(tmp2,[],2);
    v  = mean(tmp1,1) - mean(tmp2,1);
    v = v/norm(v);
    x(1) = (v(1)*cos(theta)-v(2)*sin(theta))/(v(1)^2+v(2)^2);
    y(1) = sin(theta)/v(1)+v(2)/v(1)*x(1);
    x(2) = (v(1)*cos(-theta)-v(2)*sin(-theta))/(v(1)^2+v(2)^2);
    y(2) = sin(-theta)/v(1)+v(2)/v(1)*x(2);

    %                a  = (v(1)^2+v(2)^2)*cos(theta)^2;
    %                b  = sqrt(v(1)*v(1)*v(2)*v(2)-(v(1)^2-a)*(v(2)^2-a));
    %                y1 = (-v(1)*v(2) + b)/(v(2)^2-a);
    %                y2 = (-v(1)*v(2) - b)/(v(2)^2-a);
    vecs1 = tmp1 - mean(tmp1,1);
    % for y1
    dot1theta = dot(vecs1,repmat([x(1),y(1)],[size(vecs1,1),1]),2);
    magvec1 = sqrt(vecs1(:,1).*vecs1(:,1)+vecs1(:,2).*vecs1(:,2));
    angle = dot1theta./magvec1;
    [~, I] = max(angle);
    refPointFW(t,1,:) = tmp1(I,:);
    % for y2
    dot1theta = dot(vecs1,repmat([x(2),y(2)],[size(vecs1,1),1]),2);
    magvec1 = sqrt(vecs1(:,1).*vecs1(:,1)+vecs1(:,2).*vecs1(:,2));
    angle = dot1theta./magvec1;
    [~, I] = max(angle);
    refPointFW(t,2,:) = tmp1(I,:);
end
end
