
function handles = makeUI(self)

warning('off','MATLAB:hg:uicontrol:MinMustBeLessThanMax')


% need to compute the maximum # of controls in each group
group_names = categories([self.Pstrings.Group]);
n_controls = zeros(length(group_names),1);
for i = 1:length(group_names)
    this = [self.Pstrings.Group] == group_names{i};
    n_controls(i) = sum(this);
end
n_controls = max(n_controls);



% make sure it doesn't spawn off screen
screen_size = get(0,'ScreenSize');
height = min([round(screen_size(4)*.75) self.slider_spacing*(n_controls+1)]);
height = round(height/self.slider_spacing)*self.slider_spacing;
n_rows = height/self.slider_spacing;

screen_size = screen_size(3:4);
x = screen_size(1)/3;
y = screen_size(2) - height - 100;




fig = uifigure('position',[x y 400 height],'Name','puppeteer','Scrollable','on');
fig.MenuBar = 'none';
fig.NumberTitle = 'off';
fig.IntegerHandle = 'off';

fig.CloseRequestFcn = @self.quitManipulateCallback;
fig.Resize = 'off';
fig.Color = 'w';

self.handles.fig = fig;


self.handles.tabgroup = uitabgroup(self.handles.fig);
self.handles.tabgroup.Position = [1 50 400 height-50];


% make a tab for each group



for j = 1:length(group_names)
    self.handles.tabs(j) = uitab(self.handles.tabgroup,'Title',group_names{j});

    self.handles.tabs(j).Scrollable = 'on';


    % figure out the controls in this group
    this = [self.Pstrings.Group] == group_names{j};
    pstrings = self.Pstrings(this);

    ypos = height - sum(this)*self.slider_spacing;

    ypos = self.slider_spacing;

    for i = 1:length(pstrings)


        pidx = find(strcmp(pstrings(i).Name,{self.Pstrings.Name}));

        if pstrings(i).ToggleSwitch
            sliders(pidx) = uiswitch(self.handles.tabs(j),'ValueChangedFcn',@self.valueChangingCallback,'Items',{pstrings(i).ToggleLeft, pstrings(i).ToggleRight});
            sliders(pidx).Position(2) = ypos;
            sliders(pidx).Position(1) = (400-sliders(pidx).OuterPosition(3))/2;
        else
            sliders(pidx) = uislider(self.handles.tabs(j),'Limits',[pstrings(i).Lower pstrings(i).Upper],'Value',pstrings(i).Value,'ValueChangedFcn',@self.valueChangedCallback,'MajorTickLabels',{});

       
            sliders(pidx).ValueChangingFcn = @self.valueChangingCallback;
    

            sliders(pidx).Position(1:3) = [80 ypos 230];

            sliders(pidx).MinorTicks = linspace(pstrings(i).Lower,pstrings(i).Upper,21);
            sliders(pidx).MajorTicks = linspace(pstrings(i).Lower,pstrings(i).Upper,5);

        end


        % add labels on the axes 
        thisstring = pstrings(i).Name;
        % for j = length(self.replace_these):-1:1
        %     this_name = strrep(this_name,self.replace_these{j},self.with_these{j});
        % end
        if ~pstrings(i).ToggleSwitch
            thisstring = [thisstring '= ',strlib.oval(pstrings(i).Value) pstrings(i).Units];
        end
        

        controllabel(pidx) =  uilabel(self.handles.tabs(j),'Position',[80 ypos+20 230 20],'FontSize',14,'Text',thisstring,'BackgroundColor','w','HorizontalAlignment','center');

        if ~pstrings(i).ToggleSwitch
            self.handles.lbcontrol(pidx) = uieditfield(self.handles.tabs(j),'numeric','Position',[20 ypos-7 40 20],'Value',pstrings(i).Lower,'ValueChangedFcn',@self.resetSliderBounds,'Tag',pstrings(i).Name,'Limits',[pstrings(i).LowerLimit Inf]);
            self.handles.ubcontrol(pidx) = uieditfield(self.handles.tabs(j),'numeric', 'Position',[330 ypos-7 40 20],'Value',pstrings(i).Upper,'ValueChangedFcn',@self.resetSliderBounds,'Tag',pstrings(i).Name,'HorizontalAlignment','left','Limits',[-Inf pstrings(i).UpperLimit ]);
        end



        ypos = ypos + self.slider_spacing;
        


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


% remember the original values so we can return to them
self.original_values = self.Pstrings;
