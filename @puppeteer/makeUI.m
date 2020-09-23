
function handles = makeUI(self,parameter_names,parameter_values,lb,ub,units)

warning('off','MATLAB:hg:uicontrol:MinMustBeLessThanMax')


n_controls = length(parameter_names);



% make sure it doesn't spawn off screen
screen_size = get(0,'ScreenSize');
height = min([round(screen_size(4)*.75) self.slider_spacing*(n_controls+1)]);
height = round(height/self.slider_spacing)*self.slider_spacing;
n_rows = height/self.slider_spacing;

screen_size = screen_size(3:4);
x = screen_size(1)/3;
y = screen_size(2) - height - 100;




fig = uifigure('position',[x y 400 height],'Name','puppeteer');
fig.MenuBar = 'none';
fig.NumberTitle = 'off';
fig.IntegerHandle = 'off';

fig.CloseRequestFcn = @self.quitManipulateCallback;
fig.Resize = 'off';
fig.Color = 'w';

self.handles.fig = fig;

bad_bounds = isnan(lb) | isnan(ub) | ub<lb;
lb(bad_bounds) = 0;
ub(bad_bounds) = 1;
parameter_values(bad_bounds) = .5;

self.handles.tabgroup = uitabgroup(self.handles.fig);
self.handles.tabgroup.Position = [0 0 400 height];
self.handles.tabs = uitab(self.handles.tabgroup,'Title','Group 0');

group_idx = 0;

for i = 1:n_controls


    ypos = height - self.slider_spacing*i + floor(i/n_rows)*height;


    sliders(i) = uislider(self.handles.tabs(end),'ValueChangingFcn',@self.valueChangingCallback,'Limits',[lb(i) ub(i)],'Value',parameter_values(i),'ValueChangedFcn',@self.valueChangedCallback,'MajorTickLabels',{});
    sliders(i).Position(1:3) = [80 ypos 230];


    % add labels on the axes 
    this_name = parameter_names{i};
    for j = length(self.replace_these):-1:1
    	this_name = strrep(this_name,self.replace_these{j},self.with_these{j});
    end
    thisstring = [this_name '= ',strlib.oval(parameter_values(i))];
        

    controllabel(i) =  uilabel(self.handles.tabs(end),'Position',[80 ypos+20 230 20],'FontSize',14,'Text',thisstring,'BackgroundColor','w','HorizontalAlignment','center');


    self.handles.lbcontrol(i) = uieditfield(self.handles.tabs(end),'numeric','Position',[20 ypos-7 40 20],'Value',lb(i),'ValueChangedFcn',@self.resetSliderBounds,'Tag',mat2str(i));
    self.handles.ubcontrol(i) = uieditfield(self.handles.tabs(end),'numeric', 'Position',[330 ypos-7 40 20],'Value',ub(i),'ValueChangedFcn',@self.resetSliderBounds,'Tag',mat2str(i),'HorizontalAlignment','left');


    sliders(i).MinorTicks = linspace(lb(i),ub(i),21);
    sliders(i).MajorTicks = linspace(lb(i),ub(i),5);

    if  rem(i,n_rows) == 0
        group_idx = group_idx + 1;
        self.handles.tabs = [self.handles.tabs; uitab(self.handles.tabgroup,'Title',['Group ' mat2str(group_idx)])];
    end


end

for i = 1:length(self.handles.tabs)
    self.handles.tabs(i).BackgroundColor = [1 1 1];
end

self.handles.sliders = sliders;
self.handles.controllabel = controllabel;


drawnow
warning('on','MATLAB:hg:uicontrol:MinMustBeLessThanMax')

% create a reset button
self.handles.reset = uibutton(fig,'Text','Reset');
self.handles.reset.Position = [150 10 100 20];
self.handles.reset.ButtonPushedFcn = @self.reset;
