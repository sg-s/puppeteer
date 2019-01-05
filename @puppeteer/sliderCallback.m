
function sliderCallback(self,src,event)



idx = find(self.handles.sliders == src);


% failed attempt at makign sliders auto-expand when limits are reached
% persistent last_extreme;
% persistent last_extreme_tic;

% if isempty(last_extreme)
%     last_extreme = zeros(length(self.handles.sliders),1);
% end

% if isempty(last_extreme_tic)
%     last_extreme_tic = zeros(length(self.handles.sliders),1);
% end

% % are we at the bounds?
% if src.Value == src.Max
% 	disp('max')
% 	time_since_last_extreme = now - last_extreme_tic(idx);
% 	if time_since_last_extreme < 1e-5
% 		keyboard
% 	else
% 		time_since_last_extreme(idx) = now;
% 	end
% end


% update the parameter values
self.parameter_values(idx) = src.Value;

% update the corresponding control label
this_string = self.handles.controllabel(idx).String;
this_string = this_string(1:strfind(this_string,'='));
this_string = [this_string oval(src.Value)];
self.handles.controllabel(idx).String = this_string;

if ~isempty(self.callback_function)
	self.callback_function(self.parameter_names(idx),self.parameter_values(idx))
end


