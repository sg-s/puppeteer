function reset(self,~,~)

% update sliders and labels
for i = 1:length(self.handles.sliders)
	self.handles.sliders(i).Max = self.original_ub(i);
	self.handles.sliders(i).Min = self.original_lb(i);
	self.handles.sliders(i).Value = self.original_state(i);

	% update the corresponding control label
	this_string = self.handles.controllabel(i).String;
	this_string = this_string(1:strfind(this_string,'='));
	this_string = [this_string oval(self.original_state(i))];
	self.handles.controllabel(i).String = this_string;
end

self.parameter_values = self.original_state;
self.continuous_callback_function(self.parameter_names,self.parameter_values)

