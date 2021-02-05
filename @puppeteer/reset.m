% callback for the reset button

function reset(self,~,~)


% first copy the original values from the cache to the Pstrings array
for i = 1:length(self.Pstrings)
	self.Pstrings(i).Value = self.original_values(i).Value;
end


% now update all the sliders
for i = 1:length(self.handles.sliders)

	if self.Pstrings(i).ToggleSwitch
		self.handles.sliders(i).Value = self.Pstrings(i).Value;
		continue
	end


	Value = self.Pstrings(i).Value;

	if Value > self.handles.sliders(i).Limits(2)
		event = struct('Value',Value);
		self.handles.ubcontrol(i).Value = Value;
		self.resetSliderBounds(self.handles.ubcontrol(i),event);
	end

	if Value < self.handles.sliders(i).Limits(1)
		event = struct('Value',Value);
		self.handles.lbcontrol(i).Value = Value;
		self.resetSliderBounds(self.handles.lbcontrol(i),event);
	end


	self.handles.sliders(i).Value = Value;

	% update the corresponding control label
	this_string = self.handles.controllabel(i).Text;
	this_string = this_string(1:strfind(this_string,'='));
	this_string = [this_string strlib.oval(Value)];
	self.handles.controllabel(i).Text = this_string;

end

if ~isempty(self.valueChangingFcn)
	self.valueChangingFcn(self.Pstrings)
elseif ~isempty(self.valueChangedFcn)
	self.valueChangedFcn(self.Pstrings)
end


