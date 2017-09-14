% puppeteer.m
% class to create UX elements that can manipulate parameters


classdef puppeteer < handle

	properties
		handles
		callback_function 
		parameters
		units
		attached_figures
	end

	methods

		function self = puppeteer(parameters,lb,ub)


			self.parameters = parameters;

			if iscell(parameters)
				% cell array, multiple groups
				% check that lb and ub are also cell arrays of the same size
				assert(iscell(lb),'Lower bounds should also be a cell array, like parameters')
				assert(iscell(ub),'Upper bounds should also be a cell array, like parameters')
				assert(length(parameters) == length(lb),'Lower bounds and parameters do not match')
				assert(length(parameters) == length(ub),'Upper bounds and parameters do not match')
				for i = 1:length(parameters)
					self.makeUI(parameters{i},lb{i},ub{i});
				end
			elseif isstruct(parameters)
				self.makeUI(parameters,lb,ub);
			end


		end % end constructor 

		function handles = makeUI(self,parameters,lb,ub)
			assert(isstruct(parameters),'makeUI expects structs')
			assert(isstruct(lb),'makeUI expects structs')
			assert(isstruct(ub),'makeUI expects structs')

			% which figure are we making?
			if isempty(self.handles)
				fig_no = 1;
			else
				fig_no = length(self.handles) + 1;
			end

			slider_spacing = 59;
			text_spacing = 59;
			f = fieldnames(parameters);
			n_controls = length(f);

			
			height = slider_spacing*n_controls;

            self.handles(fig_no).fig = figure('position',[1000 250 400 height], 'Toolbar','none','Menubar','none','NumberTitle','off','IntegerHandle','off','CloseRequestFcn',@self.quitManipulateCallback,'Name',['manipulate{}'],'Resize','off');

            % create an axes here, and make it invisible. 
            self.handles(fig_no).ax = axes(self.handles(fig_no).fig);
            self.handles(fig_no).ax.Units = 'pixels';
            self.handles(fig_no).ax.Position = [0 0 400 height];
            self.handles(fig_no).ax.XColor = 'w';
            self.handles(fig_no).ax.YColor = 'w';
            hold(self.handles(fig_no).ax,'on')
            self.handles(fig_no).ax.XLim = [0 400];
            self.handles(fig_no).ax.YLim = [0 height];
            

			parameters_vec = struct2mat(parameters);
			lb_vec = struct2mat(lb);
			ub_vec = struct2mat(ub);


			% TODO -- CHECK THAT BOUNDS ARE OK

            for i = 1:length(f)
                sliders(i) = uicontrol(self.handles(fig_no).fig,'Position',[80 height-i*slider_spacing 230 20],'Style', 'slider','FontSize',12,'Callback',@self.sliderCallback,'Min',lb_vec(i),'Max',ub_vec(i),'Value',parameters_vec(i));
   
                try    % R2013b and older
                   addlistener(sliders(i),'ActionEvent',@self.sliderCallback);
                catch  % R2014a and newer
                   addlistener(sliders(i),'ContinuousValueChange',@self.sliderCallback);
                end

                % add labels on the axes 
                thisstring = [f{i} '= ',mat2str(parameters_vec(i))];
                    
                controllabel(i) = text(self.handles(fig_no).ax,180,height-i*slider_spacing+40,thisstring,'FontSize',20);

                self.handles(fig_no).lbcontrol(i) = uicontrol(self.handles(fig_no).fig,'Position',[20 height-i*slider_spacing+3 40 20],'style','edit','String',mat2str(lb_vec(i)),'Callback',@self.resetSliderBounds);
                self.handles(fig_no).ubcontrol(i) = uicontrol(self.handles(fig_no).fig,'Position',[350 height-i*slider_spacing+3 40 20],'style','edit','String',mat2str(ub_vec(i)),'Callback',@self.resetSliderBounds);


            end
            self.handles(fig_no).sliders = sliders;
            self.handles(fig_no).controllabel = controllabel;


		end

		function sliderCallback(self,src,~)

			% update the corresponding control label
			for i = 1:length(self.handles)
				for j = 1:length(self.handles(i).sliders)
					if src == self.handles(i).sliders(j)
						old_text = self.handles(i).controllabel(j).String;
						new_text = [old_text(1:strfind(old_text,'=')) oval(self.handles(i).sliders(j).Value)];
						self.handles(i).controllabel(j).String = new_text;

						% don't forget to also update the parameters
						if iscell(self.parameters)
							f = fieldnames(self.parameters{i});
							self.parameters{i}.(f{j}) = src.Value;
						else
							f = fieldnames(self.parameters);
							self.parameters.(f{j}) = src.Value;
						end
						break
					end
				end
			end

			if ~isempty(self.callback_function)
				self.callback_function(self.parameters)
			end

		end % end sliderCallback

	    function resetSliderBounds(self,src,~)
	    	if isnan(str2double(src.String))
	    		return
	    	end
	    	for i = 1:length(self.handles)
		        if any(self.handles(i).lbcontrol == src)
		            % some lower bound being changed
		            this_param = find(self.handles(i).lbcontrol == src);
		            new_bound = str2double(src.String);
		            
		            if self.handles(i).sliders(this_param).Value < new_bound
		                self.handles(i).sliders(this_param).Value = new_bound;
		            end

		            self.handles(i).sliders(this_param).Min = new_bound;
		        elseif any(self.handles(i).ubcontrol == src)
		            % some upper bound being changed
		            this_param = find(self.handles(i).ubcontrol == src);
		            new_bound = str2double(src.String);
		            
		            if self.handles(i).sliders(this_param).Value > new_bound
		                self.handles(i).sliders(this_param).Value = new_bound;

		            end

		            self.handles(i).sliders(this_param).Max = new_bound;
		        end
		    end
	    end % end resetSliderBounds

	    function quitManipulateCallback(self,~,~)
            % destroy every figure in self.handles
            for i = 1:length(self.handles)
            	delete(self.handles(i).fig)
            end

            % destroy every object in self.attached_figures
            for i = 1:length(self.attached_figures)
                try
                    delete(self.attached_figures(i))
                catch
                end
            end

        end % end quitManipulateCallback 

        function attachFigure(self,fig_handle)
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