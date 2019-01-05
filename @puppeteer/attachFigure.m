function attachFigure(self,fig_handle)
% copy over the close req callback
set(fig_handle,'CloseRequestFcn',@self.quitManipulateCallback);

if isempty(self.attached_figures)
	self.attached_figures = fig_handle;
else
	if any(self.attached_figures == fig_handle)
		return
	else
		self.attached_figures = [self.attached_figures; fig_handle];
	end
	
end

