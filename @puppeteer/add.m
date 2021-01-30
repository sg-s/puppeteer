function add(self,options)

arguments
	self (1,1) puppeteer
	options.Name = ''
	options.Value = 1
	options.Lower = 0
	options.Upper = 2;
	options.LogScale = false
	options.Units = ''
	options.Group = categorical({'Parameters'})
end


if options.Lower >= options.Value
	options.Lower = options.Value/2;
end

if options.Upper <= options.Value
	options.Upper = options.Value*2;
end

if isempty(self.Pstrings)
	self.Pstrings = options;
else
	self.Pstrings = [self.Pstrings; options];
end