function feature = fZC(data_TimeWindow)
	% - ZC - Zero Crossing
	% - Input:  [data], 1xN, data from a time-window.
	% - Output: [f],    feature
	DeadZone = var(data_TimeWindow);
	data_size = length(data_TimeWindow);
	feature = 0;

	if data_size == 0
		feature = 0;
	else
		for i=2:data_size
			difference = data_TimeWindow(i) - data_TimeWindow(i-1);
			multy      = data_TimeWindow(i) * data_TimeWindow(i-1);
			if abs(difference)>DeadZone && multy<0
				feature = feature + 1;
			end
		end
		feature = feature/data_size;
	end
end
