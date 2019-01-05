function scroll(self,src,event)


slider_spacing = 59;
window_height = self.handles.fig.Position(4);




if src == self.handles.fig
	% scroll wheel
	scroll_amount = 10*event.VerticalScrollCount;
	
	% move the scroll bar
	ypos = self.handles.vertical_scroll.Max - self.handles.vertical_scroll.Value;
	ypos = ypos + scroll_amount;
	if ypos < 0
		ypos = 0;
	end
	if ypos > self.handles.vertical_scroll.Max
		ypos = self.handles.vertical_scroll.Max;
	end
	self.handles.vertical_scroll.Value = self.handles.vertical_scroll.Max - ypos;

else
	
end

y_increment = self.handles.vertical_scroll.Max - self.handles.vertical_scroll.Value;


% move all the uicontrols
for i = 1:length(self.handles.sliders)
	y = self.base_y_pos(i) + y_increment;

	self.handles.sliders(i).Position(2) = y;
	self.handles.controllabel(i).Position(2) = y+20;
	self.handles.lbcontrol(i).Position(2) = y+3;
	self.handles.ubcontrol(i).Position(2) = y+3;
end

