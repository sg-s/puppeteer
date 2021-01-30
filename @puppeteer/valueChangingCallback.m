
% this callback is called when the slider is
% moved

function valueChangingCallback(self,src,event)



idx = find(self.handles.sliders == src);



% update the parameter values
self.Pstrings(idx).Value = event.Value;

% update the corresponding control label
this_string = self.handles.controllabel(idx).Text;
this_string = this_string(1:strfind(this_string,'='));
this_string = [this_string strlib.oval(event.Value)];
self.handles.controllabel(idx).Text = this_string;


if isempty(self.valueChangingFcn)
	return
end

self.valueChangingFcn(self.Pstrings(idx).Name,event.Value)



