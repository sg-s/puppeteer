
function resetSliderBounds(self,src,~)

if isnan(str2double(src.String))
	return
end

if any(self.handles.lbcontrol == src)
    % some lower bound being changed
    this_param = find(self.handles.lbcontrol == src);
    new_bound = str2double(src.String);
    
    if self.handles.sliders(this_param).Value < new_bound
        self.handles.sliders(this_param).Value = new_bound;
    end

    self.handles.sliders(this_param).Min = new_bound;
elseif any(self.handles.ubcontrol == src)
    % some upper bound being changed
    this_param = find(self.handles.ubcontrol == src);
    new_bound = str2double(src.String);
    
    if self.handles.sliders(this_param).Value > new_bound
        self.handles.sliders(this_param).Value = new_bound;
    end

    self.handles.sliders(this_param).Max = new_bound;
end

