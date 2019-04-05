function freeze(self,~,~)

% delete all previously saved frozen traces
for i = 1:length(self.attached_figures)
	% need to do yyaxis things separately 
	ax = self.attached_figures(i).Children;

	for j = 1:length(ax)
		yyaxis(ax(j),'left') 
		lines = ax(j).Children;
		rm_this = false(length(lines),1);
		for k = 1:length(lines)
			if strcmp(lines(k).Tag,'frozen')
				rm_this(k) = true;
			end
		end
		delete(lines(rm_this))

		yyaxis(ax(j),'right') 
		lines = ax(j).Children;
		rm_this = false(length(lines),1);
		for k = 1:length(lines)
			if strcmp(lines(k).Tag,'frozen')
				rm_this(k) = true;
			end
		end
		delete(lines(rm_this))
	end

end

% now make copies of every object
for i = 1:length(self.attached_figures)
	ax = self.attached_figures(i).Children;
	for j = 1:length(ax)
		yyaxis(ax(j),'left') 
		lines = ax(j).Children;
		for k = 1:length(lines)
			temp = copy(lines(k));
			temp.Tag = 'frozen';
			temp.Parent = lines(k).Parent;
			temp.Color = 'r';
		end

		yyaxis(ax(j),'right') 
		lines = ax(j).Children;
		for k = 1:length(lines)
			temp = copy(lines(k));
			temp.Tag = 'frozen';
			temp.Parent = lines(k).Parent;
			temp.Color = 'r';
		end
	end
end

