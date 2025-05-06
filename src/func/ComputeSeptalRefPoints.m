
function refPointSep = ComputeSeptalRefPoints(app)
for t = 1 :app.TimeStepSpinner.Limits(2)
    tmp1 = squeeze(squeeze(app.CoordContours(t,1,:,:)));
    tmp2 = squeeze(squeeze(app.CoordContours(t,2,:,:)));
    tmp1(tmp1==0) = [];
    tmp1 = reshape(tmp1,[],2);
    tmp2(tmp2==0) = [];
    tmp2 = reshape(tmp2,[],2);
    p1  = mean(tmp2,1);
    p2  = mean(tmp1,1);

    indx = tmp1(:,1)<p2(1);
    tmp1_l = tmp1(indx,:);
    indx = tmp2(:,1)>p1(1);
    tmp2_r = tmp2(indx,:);

    a =   p2(2)-p1(2);
    b = -(p2(1)-p1(1));
    c =   p2(1)*p1(2)-p1(1)*p2(2);
    d1 = abs(a*tmp1_l(:,1)+b*tmp1_l(:,2)+c)/sqrt(a*a+b*b);

    [~,ind] = min(d1);
    ind = ind + size(tmp1_l,1);
    tmp1_l = repmat(tmp1_l,[3,1]);
    tmp2_r = repmat(tmp2_r,[3,1]);

    for i = ind-1:-1:1
        di = sqrt((tmp2_r(:,1)-tmp1_l(i,1)).^2+(tmp2_r(:,2)-tmp1_l(i,2)).^2);
        if min(di) > 0.4 && i < ind-30
            refPointSep(t,1,:) = tmp1_l(i+1,:);
            break;
        end
    end

    for i = ind+1:size(tmp1_l,1)
        di = sqrt((tmp2_r(:,1)-tmp1_l(i,1)).^2+(tmp2_r(:,2)-tmp1_l(i,2)).^2);
        if min(di) > 0.4 && i > ind + 30
            refPointSep(t,2,:) = tmp1_l(i-1,:);
            break;
        end
    end
end
end
