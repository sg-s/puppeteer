
function handles = makeUI(self,parameter_names,parameter_values,lb,ub,units)

warning('off','MATLAB:hg:uicontrol:MinMustBeLessThanMax')


n_controls = length(parameter_names);



% make sure it doesn't spawn off screen
screen_size = get(0,'ScreenSize');
height = min([round(screen_size(4)*.75) self.slider_spacing*(n_controls+1)]);
screen_size = screen_size(3:4);
x = screen_size(1)/3;
y = screen_size(2) - height - 100;


fig = uifigure('position',[x y 400 height]);
fig.MenuBar = 'none';
fig.NumberTitle = 'off';
fig.IntegerHandle = 'off';

fig.CloseRequestFcn = @self.quitManipulateCallback;
fig.Resize = 'off';
fig.Color = 'w';

% not working in R2018a
fig.WindowScrollWheelFcn = @self.scroll;

self.handles.fig = fig;

% % make a vertical scrollbar
% self.handles.vertical_scroll = uicontrol(self.handles.fig,'Position',[380 0 20 height],'Style', 'slider','Callback',@self.scroll,'Min',0,'Max',1,'Value',1);
% try    % R2013b and older
%    addlistener(self.handles.vertical_scroll,'ActionEvent',@self.scroll);
% catch  % R2014a and newer
%    addlistener(self.handles.vertical_scroll,'ContinuousValueChange',@self.scroll);
% end

for i = 1:n_controls
	self.base_y_pos(i) = height-i*self.slider_spacing;

    sliders(i) = uislider(self.handles.fig,'ValueChangingFcn',@self.valueChangingCallback,'Limits',[lb(i) ub(i)],'Value',parameter_values(i),'ValueChangedFcn',@self.valueChangedCallback,'MajorTickLabels',{});
    sliders(i).Position(1:3) = [80 self.base_y_pos(i) 230];


    % add labels on the axes 
    this_name = parameter_names{i};
    for j = length(self.replace_these):-1:1
    	this_name = strrep(this_name,self.replace_these{j},self.with_these{j});
    end
    thisstring = [this_name '= ',strlib.oval(parameter_values(i))];
        

    controllabel(i) =  uilabel(self.handles.fig,'Position',[80 height-i*self.slider_spacing+20 230 20],'FontSize',14,'Text',thisstring,'BackgroundColor','w','HorizontalAlignment','center');


    self.handles.lbcontrol(i) = uieditfield(self.handles.fig,'numeric','Position',[20 height-i*self.slider_spacing-7 40 20],'Value',lb(i),'ValueChangedFcn',@self.resetSliderBounds,'Tag',mat2str(i));
    self.handles.ubcontrol(i) = uieditfield(self.handles.fig,'numeric', 'Position',[330 height-i*self.slider_spacing-7 40 20],'Value',ub(i),'ValueChangedFcn',@self.resetSliderBounds,'Tag',mat2str(i),'HorizontalAlignment','left');


end
self.handles.sliders = sliders;
self.handles.controllabel = controllabel;

scroll_max = -min(self.base_y_pos);

self.handles.vertical_scroll.Max = scroll_max;
self.handles.vertical_scroll.Value = scroll_max;

drawnow
warning('on','MATLAB:hg:uicontrol:MinMustBeLessThanMax')

