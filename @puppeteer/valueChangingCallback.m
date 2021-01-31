
% this callback is called when the slider is
% moved

function valueChangingCallback(self,src,event)



idx = find(self.handles.sliders == src);

self.update(idx,event.Value);

if isempty(self.valueChangingFcn)
	return
end

self.valueChangingFcn(self.Pstrings(idx).Name,self.Pstrings(idx).Value)



