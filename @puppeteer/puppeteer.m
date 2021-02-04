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
		attached_figures
		 

		% callbacks
		valueChangingFcn function_handle
		valueChangedFcn function_handle
	end


	properties (Access = protected)
		slider_spacing (1,1) double = 70;


		% original values needs to be a cell because for 
		% toggle switches, the values aren't numbers but char
		original_values (:,1) struct

	end

	properties (SetAccess = protected) 

		Pstrings (:,1) struct 
	end

	properties (GetAccess = protected)
		x_offset double = 20;
		y_offset double = 20;
		replace_these = {'_','_2_'};
		with_these =    {' ',' -> '};
	end % end protected props

	methods

		function self = puppeteer()


		end % end constructor 



	end % end methods 




end % end classdef