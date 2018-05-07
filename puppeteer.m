% puppeteer.m
% class to create UX elements that can manipulate parameters
% puppeteer makes a bunch of sliders that you can
% move around, and connects these sliders 
% to real code that evaluates while you move the 
% sliders around. 
% 
% usage:
% puppeteer(parameters,lb,ub,units,live_update)
%
% where parameters is a cell array of names (or a cell of cells)
% lb is a cell array of vectors (lower bounds of sliders) 
% ub is a cell array of vectors (upper bounds of sliders)
% units is a cell array the same size as parameters
% live_update is a bool that determines puppeteer's behavior


classdef puppeteer < handle

	properties
		handles
		callback_function 
		parameter_values
		parameter_names
		units
		attached_figures
		group_names

		live_update = true;

		base_y_pos
	end

	properties (GetAccess = protected)
		x_offset = 20;
		y_offset = 20;
		replace_these = {'_','_2_'};
		with_these = {' ',' -> '};
	end % end protected props

	methods

		function self = puppeteer(parameter_names,parameter_values,lb,ub,units,live_update)

			assert(iscell(parameter_names),'parameter_names (first argument) should be a cell array')
			assert(isvector(parameter_values),'parameter_names (2nd argument) should be a vector array')
			assert(isvector(lb),'lower bounds (3rd argument) should be a vector array')
			assert(isvector(ub),'upper bounds (4th argument) should be a vector array')
			assert(length(parameter_names) == length(parameter_values),'Parameter names and values should have the same size')

			% if any bounds are out of order, flip them around
			for i = 1:length(ub)
				if lb(i) > ub(i)
					temp = ub(i);
					ub(i) = lb(i);
					lb(i) = temp;
				end
			end


			if isempty(units)
				units = cell(length(parameter_names),1);
			end

			self.makeUI(parameter_names,parameter_values,lb,ub,units);

			self.parameter_values = parameter_values;
			self.parameter_names = parameter_names;



		end % end constructor 

		function set.group_names(self,value)
			assert(iscell(value),'group_names should be a cell')
			assert(length(value) == length(self.parameters),'Group names should be as long as parameters -- you want one group name for each parameter group');
			for i = 1:length(self.handles)
				self.handles(i).fig.Name = value{i};
			end
		end

		function handles = makeUI(self,parameter_names,parameter_values,lb,ub,units)


			slider_spacing = 59;
			text_spacing = 59;
			n_controls = length(parameter_names);
			
			height = 900;

			x = 1000;
			y = 250;

            self.handles.fig = figure('position',[x y 400 height], 'Toolbar','none','Menubar','none','NumberTitle','off','IntegerHandle','off','CloseRequestFcn',@self.quitManipulateCallback,'Name',['manipulate{}'],'Resize','off','Color','w','WindowScrollWheelFcn',@self.scroll);

            % make a vertical scrollbar
            self.handles.vertical_scroll = uicontrol(self.handles.fig,'Position',[380 0 20 height],'Style', 'slider','Callback',@self.scroll,'Min',0,'Max',1,'Value',1);
    		try    % R2013b and older
               addlistener(self.handles.vertical_scroll,'ActionEvent',@self.scroll);
            catch  % R2014a and newer
               addlistener(self.handles.vertical_scroll,'ContinuousValueChange',@self.scroll);
            end
           
            for i = 1:n_controls
            	self.base_y_pos(i) = height-i*slider_spacing;

                sliders(i) = uicontrol(self.handles.fig,'Position',[80 self.base_y_pos(i) 230 20],'Style', 'slider','Callback',@self.sliderCallback,'Min',lb(i),'Max',ub(i),'Value',parameter_values(i));
   
                if self.live_update

	                try    % R2013b and older
	                   addlistener(sliders(i),'ActionEvent',@self.sliderCallback);
	                catch  % R2014a and newer
	                   addlistener(sliders(i),'ContinuousValueChange',@self.sliderCallback);
	                end
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

		end


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
		end

		function sliderCallback(self,src,~)

			idx = find(self.handles.sliders == src);

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

		end % end sliderCallback

	    function resetSliderBounds(self,src,~)
	    	if isnan(str2double(src.String))
	    		return
	    	end
	        if any(self.handles.lbcontrol == src)
	            % some lower bound being changed
	            this_param = find(self.handles.lbcontrol == src);
	            new_bound = str2double(src.String);
	            
	            if self.handles.sliders(this_param).Value < new_bound
	                self.handles.sliders(this_param).Value = new_bound;
	            end

	            self.handles.sliders(this_param).Min = new_bound;
	        elseif any(self.handles.ubcontrol == src)
	            % some upper bound being changed
	            this_param = find(self.handles.ubcontrol == src);
	            new_bound = str2double(src.String);
	            
	            if self.handles.sliders(this_param).Value > new_bound
	                self.handles.sliders(this_param).Value = new_bound;
	            end

	            self.handles.sliders(this_param).Max = new_bound;
	        end

	    end % end resetSliderBounds

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

        end % end quitManipulateCallback 

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
		end % end attachFigure

	end % end methods 




end % end classdef