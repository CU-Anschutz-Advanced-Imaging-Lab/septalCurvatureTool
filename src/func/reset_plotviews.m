
function reset_plotviews(app,axhandle)
limx = get(axhandle,'xlim');
h = findobj(axhandle,'Type','line');
delete(h);
xlim(axhandle,limx);
end
