
function resetSliderBounds(self,src,event)



if any(self.handles.lbcontrol == src)
    % some lower bound being changed
    this_param = find(self.handles.lbcontrol == src);
    new_bound = event.Value;
    
    if self.handles.sliders(this_param).Value < new_bound
        self.handles.sliders(this_param).Value = new_bound;
    end

    self.handles.sliders(this_param).Limits(1) = new_bound;
elseif any(self.handles.ubcontrol == src)
    % some upper bound being changed
    this_param = find(self.handles.ubcontrol == src);
    new_bound = event.Value;
    
    if self.handles.sliders(this_param).Value > new_bound
        self.handles.sliders(this_param).Value = new_bound;
    end

    self.handles.sliders(this_param).Limits(2) = new_bound;
end


self.handles.sliders(this_param).MinorTicks = linspace(self.handles.lbcontrol(this_param).Value,self.handles.ubcontrol(this_param).Value,21);
self.handles.sliders(this_param).MajorTicks = linspace(self.handles.lbcontrol(this_param).Value,self.handles.ubcontrol(this_param).Value,5);