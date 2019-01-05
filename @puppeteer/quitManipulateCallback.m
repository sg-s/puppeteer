function quitManipulateCallback(self,~,~)
% destroy every figure in self.handles
delete(self.handles.fig)

% destroy every object in self.attached_figures
for i = 1:length(self.attached_figures)
    try
        delete(self.attached_figures(i))
    catch
    end
end

