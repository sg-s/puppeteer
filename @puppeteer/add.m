function add(self,options)

arguments
	self (1,1) puppeteer
	options.Name char = ''
	options.Value (1,1) double = .1
	options.Lower (1,1) double = 0
	options.Upper (1,1) double = 1;
	options.LogScale (1,1) logical = false
	options.Units char = ''
	options.Group (1,1) categorical = categorical({'Parameters'})
	options.LowerLimit (1,1) double = -Inf
	options.UpperLimit (1,1) double = Inf
end


if options.Lower >= options.Value
	options.Lower = options.Value/2;
end

if options.Upper <= options.Value
	options.Upper = options.Value*2;
end

if options.LogScale & options.Lower < 0
	error('Cannot use a log scale with a -ve bound')
end

if options.LogScale & options.Value < 0
	error('Cannot use a log scale with a -ve bound')
end


% if options.LogScale & options.Value == 0
% 	options.Value = 1e-24;
% end

% if options.LogScale & options.Lower == 0
% 	options.Lower = options.Value*1e-3;
% end

if isempty(self.Pstrings)
	self.Pstrings = options;
else
	self.Pstrings = [self.Pstrings; options];
end