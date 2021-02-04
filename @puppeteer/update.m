function update(self, src, event)


idx = find(self.handles.sliders == src);


self.Pstrings(idx).Value = event.Value;

if self.Pstrings(idx).ToggleSwitch
	return
end


S = strlib.oval(event.Value,2);

% update the corresponding control label
this_string = self.handles.controllabel(idx).Text;
this_string = this_string(1:strfind(this_string,'='));
this_string = [this_string ' ' S self.Pstrings(idx).Units];
self.handles.controllabel(idx).Text = this_string;

