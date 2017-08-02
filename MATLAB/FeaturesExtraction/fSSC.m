function f = fSSC(data)
	% - SSC - Slope Sign Change, number times
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	DeadZone = 0;
	data_size = length(data);
	f = 0;

	if data_size == 0
		feature = 0;
	else
		for j=3:data_size
			difference1 = data(j-1) - data(j-2);
			difference2 = data(j-1) - data(j);
			Sign = difference1 * difference2;
			if Sign > 0
				if abs(difference1)>DeadZone || abs(difference2)>DeadZone
					f = f + 1;
				end
			end
		end
		f = f/data_size;
	end
end

% % % ---- To be tested