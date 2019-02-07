
% attachFigure
% attach a figure to the puppeteer object
% Attaching causes the figure to be automatically
% closed when the puppeteer window is closed
%
% See Also:
% PUPPETEER.MAKEUI

function attachFigure(self,fig_handle)

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

