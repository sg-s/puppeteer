function update(self, idx, Value)

arguments
	self (1,1) puppeteer
	idx (1,1) double 
	Value (1,1) double
end


% update the parameter values
% doing the log sliders is too confusing and too much of a pain
% will do at a later date

% if self.Pstrings(idx).LogScale
% 	f = (Value-self.Pstrings(idx).Lower)/(self.Pstrings(idx).Upper - self.Pstrings(idx).Lower);
% 	self.Pstrings(idx).Value = exp((log(self.Pstrings(idx).Upper)-log(self.Pstrings(idx).Lower))*f + log(self.Pstrings(idx).Lower));


% 	S = num2str(self.Pstrings(idx).Value,'%.2e ');

% else
self.Pstrings(idx).Value = Value;
S = strlib.oval(self.Pstrings(idx).Value);
% end

% update the corresponding control label
this_string = self.handles.controllabel(idx).Text;
this_string = this_string(1:strfind(this_string,'='));
this_string = [this_string ' ' S self.Pstrings(idx).Units];
self.handles.controllabel(idx).Text = this_string;

