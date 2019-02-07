
function handles = makeUI(self,parameter_names,parameter_values,lb,ub,units)

warning('off','MATLAB:hg:uicontrol:MinMustBeLessThanMax')

slider_spacing = 59;
n_controls = length(parameter_names);



% make sure it doesn't spawn off screen
screen_size = get(0,'ScreenSize');
height = min([round(screen_size(4)*.75) slider_spacing*(n_controls+1)]);
screen_size = screen_size(3:4);
x = screen_size(1)/3;
y = screen_size(2) - height - 100;


self.handles.fig = figure('position',[x y 400 height], 'Toolbar','none','Menubar','none','NumberTitle','off','IntegerHandle','off','CloseRequestFcn',@self.quitManipulateCallback,'Name','puppeteer','Resize','off','Color','w','WindowScrollWheelFcn',@self.scroll);

% plots
handles.menu_name(1) = uimenu('Label','Tools');
uimenu(handles.menu_name(1),'Label','Reset','Callback',@self.reset);


% make a vertical scrollbar
self.handles.vertical_scroll = uicontrol(self.handles.fig,'Position',[380 0 20 height],'Style', 'slider','Callback',@self.scroll,'Min',0,'Max',1,'Value',1);
try    % R2013b and older
   addlistener(self.handles.vertical_scroll,'ActionEvent',@self.scroll);
catch  % R2014a and newer
   addlistener(self.handles.vertical_scroll,'ContinuousValueChange',@self.scroll);
end

for i = n_controls:-1:1
	self.base_y_pos(i) = height-i*slider_spacing;

    sliders(i) = uicontrol(self.handles.fig,'Position',[80 self.base_y_pos(i) 230 20],'Style', 'slider','Callback',@self.sliderCallback,'Min',lb(i),'Max',ub(i),'Value',parameter_values(i),'ButtonDownFcn',@self.sliderButtonCallback);


    try    % R2013b and older
       addlistener(sliders(i),'ActionEvent',@self.sliderCallbackContinuous);
    catch  % R2014a and newer
       addlistener(sliders(i),'ContinuousValueChange',@self.sliderCallbackContinuous);
    end


    % add labels on the axes 
    this_name = parameter_names{i};
    for j = length(self.replace_these):-1:1
    	this_name = strrep(this_name,self.replace_these{j},self.with_these{j});
    end
    thisstring = [this_name '= ',oval(parameter_values(i))];
        

    controllabel(i) =  uicontrol(self.handles.fig,'Position',[80 height-i*slider_spacing+20 230 20],'Style', 'text','FontSize',14,'String',thisstring,'BackgroundColor','w');


    self.handles.lbcontrol(i) = uicontrol(self.handles.fig,'Position',[20 height-i*slider_spacing+3 40 20],'style','edit','String',mat2str(lb(i)),'Callback',@self.resetSliderBounds);
    self.handles.ubcontrol(i) = uicontrol(self.handles.fig,'Position',[330 height-i*slider_spacing+3 40 20],'style','edit','String',mat2str(ub(i)),'Callback',@self.resetSliderBounds);


end
self.handles.sliders = sliders;
self.handles.controllabel = controllabel;

scroll_max = -min(self.base_y_pos);

self.handles.vertical_scroll.Max = scroll_max;
self.handles.vertical_scroll.Value = scroll_max;

drawnow
warning('on','MATLAB:hg:uicontrol:MinMustBeLessThanMax')

