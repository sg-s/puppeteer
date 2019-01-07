% puppeteer.m
% class to create UX elements that can manipulate parameters
% puppeteer makes a bunch of sliders that you can
% move around, and connects these sliders 
% to real code that evaluates while you move the 
% sliders around. 
% 
% usage:
% puppeteer(parameter_names,parameters,lb,ub,units)
%
% where parameters is a cell array of names (or a cell of cells)
% lb is a cell array of vectors (lower bounds of sliders) 
% ub is a cell array of vectors (upper bounds of sliders)
% units is a cell array the same size as parameters
% live_update is a bool that determines puppeteer's behavior


classdef puppeteer < handle

	properties
		handles
		parameter_values
		parameter_names
		units
		attached_figures

		base_y_pos

		% callbacks
		ValueChangedFcn@function_handle
		ValueChangingFcn@function_handle
	end

	properties (GetAccess = protected)
		x_offset = 20;
		y_offset = 20;
		replace_these = {'_','_2_'};
		with_these =    {' ',' -> '};
	end % end protected props

	methods

		function self = puppeteer(parameter_names,parameter_values,lb,ub,units)

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



	end % end methods 




end % end classdef