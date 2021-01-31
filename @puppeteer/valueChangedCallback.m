function valueChangedCallback(self,src,event)



idx = find(self.handles.sliders == src);

self.update(idx,event.Value);


if isempty(self.valueChangedFcn)
	return
end

self.valueChangedFcn(self.Pstrings(idx).Name,self.Pstrings(idx).Value)

