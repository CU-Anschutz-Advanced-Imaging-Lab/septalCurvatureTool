function tf_concav = findConcaveShape(app,arch,a,window,dist)
% smoothing twice with Gaussian filter
smdata = smoothdata(smoothdata(arch,'gaussian'),'gaussian');
%smdata = smoothdata(arch,'gaussian');
% basis
if ~isinf(a)
    nx = [1 a];
    nx = nx/norm(nx);
    ny = [-nx(2) nx(1)];
else
    nx = [0 1];
    ny = [1 0];
end

curve_in_coord_b = ([nx' ny']'*smdata')';
dydx = gradient(curve_in_coord_b(:,2))./ gradient(curve_in_coord_b(:,1));
d2ydx2 = gradient(dydx)./ gradient(curve_in_coord_b(:,1));
ind_inflect_inner = find(d2ydx2(1:end-1).*d2ydx2(2:end)<0);
ind_inflect = [0;ind_inflect_inner;size(arch,1)]; % add 0 for the loop later
if isempty(ind_inflect_inner)
    tf_concav(size(arch,1),1) = false;
else
    % go back to image coordinate and find the point convex to LV
    for ip = 1 : length(ind_inflect_inner) + 1
        %[~,indmin] = min((arch(floor((ind_inflect(ip)+1+ind_inflect(ip+1))/2),1) - chord(:,1)).^2 + (arch(floor((ind_inflect(ip)+1+ind_inflect(ip+1))/2),2) - chord(:,2)).^2);
        if a > 0 && mean(d2ydx2(ind_inflect(ip)+1:ind_inflect(ip+1))) > 0 || a < 0 && mean(d2ydx2(ind_inflect(ip)+1:ind_inflect(ip+1))) < 0
            tf_concav(ind_inflect(ip)+1:ind_inflect(ip+1),1) = true;
        else
            tf_concav(ind_inflect(ip)+1:ind_inflect(ip+1),1) = false;

        end
    end
end
end
