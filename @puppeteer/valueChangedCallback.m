function valueChangedCallback(self,src,event)


idx = find(self.handles.sliders == src);



% update the parameter values
self.parameter_values(idx) = event.Value;

% update the corresponding control label
this_string = self.handles.controllabel(idx).Text;
this_string = this_string(1:strfind(this_string,'='));
this_string = [this_string strlib.oval(event.Value)];
self.handles.controllabel(idx).Text = this_string;


if isempty(self.valueChangedFcn)
	return
end

self.valueChangedFcn(self.parameter_names(idx),self.parameter_values(idx))



