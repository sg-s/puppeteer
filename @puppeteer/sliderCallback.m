
% this callback is called when the slider is
% moved, then released

function sliderCallback(self,src,event)

idx = find(self.handles.sliders == src);



% update the parameter values
self.parameter_values(idx) = src.Value;

% update the corresponding control label
this_string = self.handles.controllabel(idx).String;
this_string = this_string(1:strfind(this_string,'='));
this_string = [this_string strlib.oval(src.Value)];
self.handles.controllabel(idx).String = this_string;

if isempty(self.callback_function)
	return
end

self.callback_function(self.parameter_names(idx),self.parameter_values(idx))



