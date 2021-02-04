function valueChangedCallback(self,src,event)

self.update(src,event);

idx = find(self.handles.sliders == src);



if ~isempty(self.valueChangedFcn)
	self.valueChangedFcn(self.Pstrings(idx));
end

