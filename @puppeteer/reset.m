function reset(self,~,~)

self.parameter_values = self.original_values;

for i = 1:length(self.handles.sliders)


	if self.parameter_values(i) > self.handles.sliders(i).Limits(2)
		event = struct('Value',self.parameter_values(i));
		self.handles.ubcontrol(i).Value = self.parameter_values(i);
		self.resetSliderBounds(self.handles.ubcontrol(i),event);
	end

	if self.parameter_values(i) < self.handles.sliders(i).Limits(1)
		event = struct('Value',self.parameter_values(i));
		self.handles.lbcontrol(i).Value = self.parameter_values(i);
		self.resetSliderBounds(self.handles.lbcontrol(i),event);
	end


	self.handles.sliders(i).Value = self.parameter_values(i);

	% update the corresponding control label
	this_string = self.handles.controllabel(i).Text;
	this_string = this_string(1:strfind(this_string,'='));
	this_string = [this_string strlib.oval(self.parameter_values(i))];
	self.handles.controllabel(i).Text = this_string;

end

if ~isempty(self.valueChangedFcn)
	self.valueChangedFcn(self.parameter_names,self.parameter_values)
	return
end


if ~isempty(self.valueChangingFcn)
	self.valueChangingFcn(self.parameter_names,self.parameter_values)
	return
end
