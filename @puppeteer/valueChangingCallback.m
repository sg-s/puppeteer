function valueChangingCallback(self,src,event)

self.update(src,event);

idx = find(self.handles.sliders == src);

if ~isempty(self.valueChangingFcn)
	self.valueChangingFcn(self.Pstrings(idx));
end

